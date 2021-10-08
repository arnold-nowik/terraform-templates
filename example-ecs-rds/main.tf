terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.61.0"
    }
  }
  backend "s3" {
    bucket  = "terraform-state-test-444555666"
    key     = "stg/terraform.tfstate"
    profile = "example"
  }
}

provider "aws" {
  profile = "example"
  region  = local.region
}

locals {
  region            = "us-east-1"
  ec2_instance_type = "t3.small"
  rds_instance_type = "db.t3.small"
}

variable "db_username" {
  description = "Database administrator username"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Database administrator password"
  type        = string
  sensitive   = true
}

variable "ecs_repository_name" {
  description = "Docker repository name"
  type        = string
  default     = "nginx"
}

variable "ecs_repository_uri" {
  description = "Dockerhub or ECR repo URI"
  type        = string
  default     = "nginx:latest"
}

