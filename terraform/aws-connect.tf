provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

module "demo_network" {
  source          = "./modules/network"
  key-name        = var.aws_key-name
  region          = var.aws_region
  client          = var.client
  ami-id          = var.aws_ami-id
  vpc-cidr        = var.aws_vpc-cidr
  public-subnet   = var.aws_public-subnet
  private-subnets = var.aws_private-subnets
}

resource "aws_instance" "connect-cluster" {
  count             = var.aws_connect-count
  ami               = var.aws_ami-id
  instance_type     = var.aws_connect-instance-type
  availability_zone = var.aws_availability-zone
  key_name          = var.aws_key-name
  tags = {
    Name        = "${var.client}-connect-${count.index}-${var.aws_availability-zone}"
    description = "Connect nodes - Managed by Terraform"
    role        = "connect"
    sshUser     = var.linux-user
    region      = var.aws_region
    role_region = "connect-${var.aws_region}"
  }

  root_block_device {
    volume_size = 100 # 1TB
  }

  subnet_id                   = module.demo_network.subnet_id
  vpc_security_group_ids      = [module.demo_network.security-group]
  associate_public_ip_address = true
}

resource "aws_route53_record" "connect-cluster" {
  count   = var.aws_connect-count
  zone_id = module.demo_network.hosted-zone-id
  name    = "connect-${count.index}.${var.client}"
  type    = "A"
  ttl     = "300"
  records = ["${element(aws_instance.connect-cluster.*.private_ip, count.index)}"]
}

resource "local_file" "ansible_inventory" {
    content = templatefile("../ansible/templates/hosts.tmpl", 
    {
        linux_user = var.linux-user
        private_key_file = module.demo_network.private-key-name
        confluent_cloud_bootstrap_server = confluent_kafka_cluster.demo_cluster_2.bootstrap_endpoint
        connect_nodes = aws_instance.connect-cluster.*.public_dns
    })
    filename = "../ansible/${data.confluent_environment.env.display_name}-inventory.yml"
}
