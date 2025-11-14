# Lesson 5 – Terraform AWS Infrastructure

This project contains Terraform configuration for:

- S3 bucket + DynamoDB table for Terraform backend
- VPC with public and private subnets, IGW and NAT
- ECR repository for Docker images

## Structure

- `main.tf` – main entry, modules wiring, provider configuration
- `backend.tf` – Terraform backend configuration (S3 + DynamoDB)
- `outputs.tf` – global outputs
- `modules/s3-backend` – S3 bucket + DynamoDB for state
- `modules/vpc` – VPC, subnets, routing, NAT/IGW
- `modules/ecr` – ECR repository

## Commands

```bash
terraform init
terraform plan
terraform apply
terraform destroy
### Note about AWS account

My AWS account is currently closed (free plan has ended), so `terraform plan` / `terraform apply`
could not be executed against a real AWS environment.

All Terraform code, modules (S3 backend + DynamoDB, VPC, ECR), backend configuration
and project structure are fully implemented according to the assignment requirements.
