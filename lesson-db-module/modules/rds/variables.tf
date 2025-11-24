variable "use_aurora" {
  description = "If true – create Aurora cluster, otherwise single RDS instance"
  type        = bool
  default     = false
}

variable "engine" {
  description = "Engine for classic RDS instance (e.g. postgres, mysql)"
  type        = string
  default     = "postgres"
}

variable "aurora_engine" {
  description = "Engine for Aurora (e.g. aurora-postgresql, aurora-mysql)"
  type        = string
  default     = "aurora-postgresql"
}

variable "engine_version" {
  description = "Database engine version"
  type        = string
  default     = "15.3"
}

variable "instance_class" {
  description = "Instance class for RDS or Aurora instances"
  type        = string
  default     = "db.t3.small"
}

variable "allocated_storage" {
  description = "Allocated storage for classic RDS instance (in GB)"
  type        = number
  default     = 20
}

variable "multi_az" {
  description = "Enable Multi-AZ for RDS instance"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Whether the DB should be publicly accessible"
  type        = bool
  default     = false
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "app_db"
}

variable "username" {
  description = "Master username"
  type        = string
  default     = "app_user"
}

variable "password" {
  description = "Master password (do NOT use in production as plain text)"
  type        = string
  default     = "ChangeMe123!"
  sensitive   = true
}

variable "vpc_id" {
  description = "VPC ID where RDS will be placed"
  type        = string
  default     = "vpc-xxxxxx"
}

variable "subnet_ids" {
  description = "List of subnet IDs for DB subnet group"
  type        = list(string)
  default     = ["subnet-aaaaaa", "subnet-bbbbbb"]
}

variable "parameter_group_family" {
  description = "Parameter group family (e.g. postgres15, aurora-postgresql15)"
  type        = string
  default     = "postgres15"
}

variable "port" {
  description = "Database port (5432 for Postgres, 3306 for MySQL)"
  type        = number
  default     = 5432
}

variable "identifier" {
  description = "Base identifier for DB resources"
  type        = string
  default     = "lesson-db-module"
}

