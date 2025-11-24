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

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "dummy-backend-bucket"
  table_name  = "terraform-locks"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_name           = "lesson-8-9-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "lesson-8-9-django-ecr"
  scan_on_push = true
}

module "eks" {
  source = "./modules/eks"

  cluster_name = "lesson-8-9-eks"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = []

  node_group_min_size     = 2
  node_group_max_size     = 4
  node_group_desired_size = 2
  instance_type           = "t3.small"
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

########################
# Jenkins via Helm
########################

module "jenkins" {
  source        = "./modules/jenkins"
  namespace     = "jenkins"
  chart_version = "5.0.3"
}

########################
# Argo CD via Helm
########################

module "argo_cd" {
  source        = "./modules/argo_cd"
  namespace     = "argocd"
  chart_version = "5.51.6"
}
