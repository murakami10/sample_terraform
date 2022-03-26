
resource "aws_db_subnet_group" "sample" {
  name_prefix = "sample-"
  subnet_ids  = aws_subnet.sample_private[*].id
  description = "RDS Aurora MySQL subnet for sample"

  tags = {
    Name = "sample"
  }
}

resource "aws_rds_cluster_parameter_group" "sample" {
  name_prefix = "sample-"
  description = "Aurora cluster parameter group for sample"
  family      = "aurora-mysql5.7"

  parameter {
    apply_method = "immediate"
    name         = "character_set_client"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_connection"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_database"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_results"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "character_set_server"
    value        = "utf8mb4"
  }

  parameter {
    apply_method = "immediate"
    name         = "collation_server"
    value        = "utf8mb4_bin"
  }

  parameter {
    apply_method = "immediate"
    name         = "collation_connection"
    value        = "utf8mb4_bin"
  }

  parameter {
    apply_method = "immediate"
    name         = "time_zone"
    value        = "Asia/Tokyo"
  }

  tags = {
    Name = "sample"
  }
}

resource "aws_db_parameter_group" "sample" {
  name_prefix = "sample-"
  description = "Aurora parameter group for sample"
  family      = "aurora-mysql5.7"

  parameter {
    apply_method = "immediate"
    name         = "innodb_large_prefix"
    value        = "1"
  }

  parameter {
    apply_method = "immediate"
    name         = "innodb_file_format"
    value        = "Barracuda"
  }

  parameter {
    apply_method = "immediate"
    name         = "max_connections"
    value        = 4096
  }

  #  slow query を有効する
  parameter {
    apply_method = "immediate"
    name         = "slow_query_log"
    value        = 1
  }

  #  何秒からslow queryかを設定する
  parameter {
    apply_method = "immediate"
    name         = "long_query_time"
    value        = 0.5
  }

  tags = {
    Name = "sample"
  }
}

resource "aws_rds_cluster" "sample" {
  cluster_identifier_prefix = "sample-"
  engine                    = "aurora-mysql"
  engine_version            = "5.7.mysql_aurora.2.09.1"
  master_username           = "root"
  master_password           = "dummydummydummydummy"

  // 利用者の少ない土曜日深夜に設定
  preferred_maintenance_window    = "sat:16:30-sat:17:30" // sun 01:30-02:30 JST
  storage_encrypted               = true
  vpc_security_group_ids          = [aws_security_group.sample_rds.id]
  db_subnet_group_name            = aws_db_subnet_group.sample.name
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.sample.name
  enabled_cloudwatch_logs_exports = ["error", "slowquery"]

  tags = {
    Name = "sample"
  }

  lifecycle {
    ignore_changes = [
      engine_version
    ]
  }
}

resource "aws_rds_cluster_instance" "sample" {
  count                   = 1
  identifier              = "sample-${count.index}"
  cluster_identifier      = aws_rds_cluster.sample.cluster_identifier
  db_subnet_group_name    = aws_db_subnet_group.sample.name
  db_parameter_group_name = aws_db_parameter_group.sample.name
  engine                  = aws_rds_cluster.sample.engine
  engine_version          = aws_rds_cluster.sample.engine_version
  instance_class          = "db.t3.small"

  tags = {
    Name = "sample"
  }
}
