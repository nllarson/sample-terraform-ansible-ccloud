terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "1.4.0"
    }
  }
}

## Confluent Cloud

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

data "confluent_environment" "env" {
  id = var.confluent_environment_id
}

resource "confluent_kafka_cluster" "demo_cluster_1" {
  display_name = "nick_demo_1"
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "us-east-2"
  basic {}
  environment {
    id = data.confluent_environment.env.id
  }
}

resource "confluent_kafka_cluster" "demo_cluster_2" {
  display_name = "nick_demo_2"
  availability = "SINGLE_ZONE"
  cloud        = "AWS"
  region       = "us-east-2"
  basic {}
  environment {
    id = data.confluent_environment.env.id
  }
}

