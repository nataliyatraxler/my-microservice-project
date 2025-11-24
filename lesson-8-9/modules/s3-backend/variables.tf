variable "bucket_name" {
  description = "Name of S3 bucket for Terraform backend"
  type        = string
}

variable "table_name" {
  description = "Name of DynamoDB table for state locking"
  type        = string
  default     = "terraform-locks"
}
