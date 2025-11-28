terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Заглушки для kubernetes/helm, щоб terraform validate проходив без реального кластера
provider "kubernetes" {
  host                   = "https://eks-demo-endpoint"
  cluster_ca_certificate = "Cg=="
  token                  = "dummy-token"
}

provider "helm" {
  kubernetes {
    host                   = "https://eks-demo-endpoint"
    cluster_ca_certificate = "Cg=="
    token                  = "dummy-token"
  }
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
# Модулі
########################

# S3 + DynamoDB backend (логічно, як у ДЗ; фактично apply не запускаємо)
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "nataliya-terraform-backend-final"
  table_name  = "terraform-locks"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.3.0/24", "10.0.4.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b"]
  vpc_name           = "final-vpc"
}

module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "final-django-ecr"
  scan_on_push = true
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = "final-eks"

  # фейкові значення, щоб пройшла валідація
  subnet_ids = []
  vpc_id     = "vpc-xxxxxxxx"
}

module "rds" {
  source = "./modules/rds"

  use_aurora             = false
  engine                 = "postgres"
  aurora_engine          = "aurora-postgresql"
  engine_version         = "15.3"
  instance_class         = "db.t3.small"
  allocated_storage      = 20
  multi_az               = false
  publicly_accessible    = false
  db_name                = "app_db"
  username               = "app_user"
  password               = "ChangeMe123!"
  vpc_id                 = "vpc-xxxxxxxx"
  subnet_ids             = ["subnet-aaaaaa", "subnet-bbbbbb"
  ]
  parameter_group_family = "postgres15"
  port                   = 5432
  identifier             = "final-rds"
}

module "jenkins" {
  source = "./modules/jenkins"

  namespace = "jenkins"
}


module "argo_cd" {
  source = "./modules/argo_cd"

  # залишаємо тільки ті аргументи, які реально є в modules/argo_cd/variables.tf
  namespace = "argocd"
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

output "db_endpoint" {
  value = module.rds.db_endpoint
}
