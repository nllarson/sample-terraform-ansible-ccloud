
provider "aws" {
  region = var.region
}

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true


  tags = {
    Name = "${var.client}-vpc"
  }
}

data "http" "myip" {
  url = "https://checkip.amazonaws.com"
}

resource "aws_internet_gateway" "internet-gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.client} IGW"
  }
}

resource "aws_subnet" "demo-public-subnet" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public-subnet.cidr_block
  availability_zone       = var.public-subnet.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.client} Public Subnet"
  }
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway.id
  }

  tags = {
    Name = "${var.client} Public Route Table"
  }
}

resource "aws_route_table_association" "public-subnet-route-table-association" {
  subnet_id      = aws_subnet.demo-public-subnet.id
  route_table_id = aws_route_table.public-route-table.id
}

resource "aws_subnet" "demo-private-subnet" {
  for_each                = { for subnet in var.private-subnets : subnet.name => subnet }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.client} Private Subnet"
  }
}

resource "aws_security_group" "all-sg" {
  name        = "all-${var.client}-sg"
  description = "Allows free traffic between all instances within the ${var.client} VPC"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow all access within the ${var.client}"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.client} Internal Access"
  }
}

resource "aws_security_group" "external-access" {
  name        = "external-access-sg"
  description = "Allows free traffic from a specific IP"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Allow all access from a specific host"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${chomp(data.http.myip.body)}/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.client} External Access"
  }
}

resource "tls_private_key" "aws-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key-pair" {
  key_name   = var.key-name
  public_key = tls_private_key.aws-key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.aws-key.private_key_pem
  filename        = "${var.key-name}.pem"
  file_permission = "0600"
}

resource "aws_route53_zone" "private" {
  name = "${var.client}.confluent.io"

  vpc {
    vpc_id = aws_vpc.vpc.id
  }
}

resource "aws_instance" "jumphost" {
  ami           = var.ami-id
  instance_type = "t3.micro"
  key_name      = aws_key_pair.key-pair.key_name

  root_block_device {
    volume_size = 50
  }

  subnet_id                   = aws_subnet.demo-public-subnet.id
  vpc_security_group_ids      = [aws_security_group.all-sg.id, aws_security_group.external-access.id]
  associate_public_ip_address = true

  tags = {
    Name        = "${var.client} Jumphost"
    description = "Jumphost for ${var.client} - Managed by Terraform"
    sshUser     = var.linux-user
    region      = var.region
  }
}

output "subnet_id" {
  value = aws_subnet.demo-public-subnet.id
}

output "private-key-name" {
  description = "The private key name needed to log into the jumphost"
  value       = local_file.private_key.filename
}

output "jumphost-ip" {
  description = "The jumphost IP. Remember that the username is 'ubuntu'"
  value       = aws_instance.jumphost.public_ip
}

output "vpc-id" {
  description = "The IP of the bootcamp VPC"
  value       = aws_vpc.vpc.id
}

output "security-group" {
  description = "Id of the security group for internal access"
  value       = aws_security_group.all-sg.id
}

output "private-subnets" {
  value = tomap({
    for k, subnet in aws_subnet.demo-private-subnet : k => subnet.id
  })
}

output "hosted-zone-id" {
  description = "Route 53 internal hosted zone"
  value       = aws_route53_zone.private.id
}
