#subnet group
resource "aws_db_subnet_group" "three_tier_app_subnet_group" {
  name       = "${lower(replace(var.project_name, "_", "-"))}-subnet-group"
  subnet_ids = [var.private_subnets[2], var.private_subnets[3]]

  tags = {
    Name = "${var.project_name}-subnet-group"
  }
}

#Password generator
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}

#secrets manager
resource "aws_secretsmanager_secret" "rds_secret" {
  name                    = "${var.project_name}-rds-secret"
  recovery_window_in_days = 7
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode(
    {
      username = var.db_username
      password = random_password.db_password.result
      engine   = var.engine
      host     = aws_db_instance.three_tier_rds_database.address
      port     = aws_db_instance.three_tier_rds_database.port
      dbname   = var.db_name
    }
  )

}

#rds
resource "aws_db_instance" "three_tier_rds_database" {
  identifier             = "${lower(replace(var.project_name, "_", "-"))}-db"
  db_name                = var.db_name
  instance_class         = var.instance_class
  engine                 = var.engine
  engine_version         = var.engine_version
  allocated_storage      = 20
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.three_tier_app_subnet_group.name
  vpc_security_group_ids = [var.rds_sg_id]
  storage_encrypted      = true
  publicly_accessible    = false
  multi_az               = false
  port                   = 3306
  username               = var.db_username
  password               = random_password.db_password.result

  tags = {
    Name = "${var.project_name}-database"
  }
}