# Aurora MySQL cluster with password managed in AWS Secrets Manager
resource "aws_rds_cluster" "aurora" {
  cluster_identifier = "${var.project_name}-aurora"
  engine             = "aurora-mysql"
  engine_version     = var.engine_version
  database_name      = var.database_name
  master_username    = var.master_username

  # Generates the master password and stores it in Secrets Manager (no plaintext)
  manage_master_user_password = true

  db_subnet_group_name      = var.db_subnet_group_name
  vpc_security_group_ids    = [var.db_sg_id]
  storage_encrypted         = true
  backup_retention_period   = var.backup_retention_period
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : "${var.project_name}-aurora-final"

  tags = {
    Name = "${var.project_name}-aurora"
  }
}

# Cluster instances (writer + reader spread across AZs for multi-AZ HA)
resource "aws_rds_cluster_instance" "aurora" {
  count              = var.instance_count
  identifier         = "${var.project_name}-aurora-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version

  tags = {
    Name = "${var.project_name}-aurora-${count.index + 1}"
  }
}
