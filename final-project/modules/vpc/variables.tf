variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "public_subnets" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
}

variable "private_subnets" {
  type        = list(string)
  description = "CIDR blocks for private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "Availability zones for subnets"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
}
