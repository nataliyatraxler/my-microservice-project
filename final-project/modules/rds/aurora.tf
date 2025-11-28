resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = "${var.identifier}-cluster"

  engine         = var.aurora_engine
  engine_version = var.engine_version

  database_name   = var.db_name
  master_username = var.username
  master_password = var.password

  db_subnet_group_name            = aws_db_subnet_group.this.name
  vpc_security_group_ids          = [aws_security_group.this.id]
  db_cluster_parameter_group_name = aws_db_parameter_group.this.name

  port = var.port

  skip_final_snapshot = true
}

resource "aws_rds_cluster_instance" "this" {
  count = var.use_aurora ? 1 : 0

  identifier = "${var.identifier}-writer-${count.index}"
  cluster_identifier = aws_rds_cluster.this[0].id

  instance_class = var.instance_class
  engine         = var.aurora_engine

  publicly_accessible = var.publicly_accessible
}


