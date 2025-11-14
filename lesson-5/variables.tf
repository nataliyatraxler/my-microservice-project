variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "backend_bucket_name" {
  description = "Globally unique S3 bucket name for Terraform backend"
  type        = string
  default     = "nataliya-terraform-backend-2025" #
}
