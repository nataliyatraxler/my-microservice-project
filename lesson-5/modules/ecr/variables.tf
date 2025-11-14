variable "ecr_name" {
  type        = string
  description = "Name of the ECR repository"
}

variable "scan_on_push" {
  type        = bool
  description = "Whether to scan images on push"
  default     = true
}
