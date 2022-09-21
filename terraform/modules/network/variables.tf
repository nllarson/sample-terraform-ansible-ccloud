variable "key-name" {
  type = string
}

variable "region" {
  type = string
}

variable "client" {
  type = string
}

variable "linux-user" {
  default = "ubuntu"
}

variable "ami-id" {
  type = string
}

variable "vpc-cidr" {
  default     = "172.32.0.0/16"
  description = "The CIDR block for your VPC"
  type        = string
}

variable "public-subnet" {
  description = "Public Subnet"
  type = object({
    name              = string
    cidr_block        = string
    availability_zone = string
  })
}

variable "private-subnets" {
  description = "Map of Private Subnets"
  type = list(object({
    name              = string
    cidr_block        = string
    availability_zone = string
  }))
}