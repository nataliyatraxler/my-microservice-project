variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where EKS will be created"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets for EKS cluster and node group"
  type        = list(string)
}

variable "node_group_min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 2
}

variable "node_group_max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 4
}

variable "node_group_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "EC2 instance type for worker nodes"
  type        = string
  default     = "t3.small"
}
