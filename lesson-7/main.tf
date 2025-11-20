terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

########################
# Змінні
########################

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

########################
# Модуль VPC
########################

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_name           = "lesson-7-vpc"
}

########################
# Модуль ECR
########################

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-7-django-ecr"
  scan_on_push = true
}

########################
# Модуль EKS
########################

module "eks" {
  source = "./modules/eks"

  cluster_name = "lesson-7-eks"
  vpc_id       = module.vpc.vpc_id
  # TODO: у реальному AWS тут треба використати output з VPC-модуля,
  # наприклад module.vpc.private_subnet_ids
  subnet_ids   = []

  node_group_min_size     = 2
  node_group_max_size     = 4
  node_group_desired_size = 2
  instance_type           = "t3.small"
}

########################
# Outputs
########################

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
