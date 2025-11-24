output "db_endpoint" {
  description = "Endpoint of the created database (RDS or Aurora)"
  value       = var.use_aurora ? aws_rds_cluster.this[0].endpoint : aws_db_instance.this[0].address
}

output "db_port" {
  description = "Database port"
  value       = var.port
}

