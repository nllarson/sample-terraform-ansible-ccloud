variable "client" {
  type = string
}

variable "confluent_cloud_api_key" {
  description = "Confluent Cloud API Key (also referred as Cloud API ID)"
  type        = string
}

variable "confluent_cloud_api_secret" {
  description = "Confluent Cloud API Secret"
  type        = string
  sensitive   = true
}

variable "confluent_environment_id" {
  description = "Confleunt Cloud Environment ID"
  type        = string
  sensitive   = true
}

variable "aws_key-name" {
  type = string
}
variable "aws_profile" { type = string }


variable "aws_region" {
  type = string
}

variable "aws_availability-zone" {
  type = string
}

variable "aws_ami-id" {
  type = string
}

variable "aws_vpc-cidr" {
  default     = "172.32.0.0/16"
  description = "The CIDR block for your VPC"
  type        = string
}

variable "aws_public-subnet" {
  description = "Public Subnet"
  type = object({
    name              = string
    cidr_block        = string
    availability_zone = string
  })
}

variable "aws_private-subnets" {
  description = "Map of Private Subnets"
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}

variable "aws_connect-count" {
  default = 0
}

variable "aws_connect-instance-type" {
  default = "t3.small"
}

variable "linux-user" {
  default = "ubuntu"
}

