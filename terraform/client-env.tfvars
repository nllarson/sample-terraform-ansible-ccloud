## General Info
client = "client"

## Confluent Cloud Info
#confluent_cloud_api_key    = <<YOUR API KEY GOES HERE -- OR -- as an ENV variable>>
#confluent_cloud_api_secret = <<YOUR API SECRET GOES HERE -- OR -- as an ENV variable>>
#confluent_environment_id   = <<YOUR CC ENV ID GOES HERE -- OR -- as an ENV variable>>

# AWS Info
aws_key-name          = "client-demo"
aws_profile           = "default"
aws_region            = "us-east-2"
aws_availability-zone = "us-east-2a"
aws_ami-id            = "ami-0568773882d492fc8"

aws_vpc-cidr = "172.32.0.0/16"

aws_public-subnet = {
  "name"              = "public-subnet",
  "cidr_block"        = "172.32.0.0/24",
  "availability_zone" = "us-east-2a"
}

aws_private-subnets = [
  {
    "name"              = "private-subnet-1",
    "cidr_block"        = "172.32.1.0/24",
    "availability_zone" = "us-east-2a"
  },
  {
    "name"              = "private-subnet-2",
    "cidr_block"        = "172.32.2.0/24",
    "availability_zone" = "us-east-2b"
  },
  {
    "name"              = "private-subnet-3",
    "cidr_block"        = "172.32.3.0/24",
    "availability_zone" = "us-east-2c"
  }
]


aws_connect-count         = 2
aws_connect-instance-type = "t3a.large"
