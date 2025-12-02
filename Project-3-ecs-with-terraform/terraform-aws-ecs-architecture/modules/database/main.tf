#Subnet Group
resource "aws_db_subnet_group" "ecs_tier_rds_db_subnet_group" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [var.private_subnet_ids[2], var.private_subnet_ids[3]]

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

#Password Manager
resource "random_password" "ecs_create_db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
  min_lower        = 1
  min_upper        = 1
  min_numeric      = 1
  min_special      = 1
}

#Secret Manager
resource "aws_secretsmanager_secret" "ecs_rds_secret" {
  name                    = "${var.project_name}-ecs-rdssssss-secret-new"
  recovery_window_in_days = 7
}
resource "aws_secretsmanager_secret_version" "ecs_rds_secret_version" {
  secret_id = aws_secretsmanager_secret.ecs_rds_secret.id
  secret_string = jsonencode(
    {
      username = var.db_username
      password = random_password.ecs_create_db_password.result
      engine   = var.engine
      host     = aws_db_instance.ecs_tier_rds_database.address
      port     = aws_db_instance.ecs_tier_rds_database.port
      dbname   = var.db_name
    }
  )
  depends_on = [aws_db_instance.ecs_tier_rds_database]
}


#Database
resource "aws_db_instance" "ecs_tier_rds_database" {
  identifier             = "${var.project_name}-db"
  db_name                = var.db_name
  instance_class         = var.instance_class
  engine                 = var.engine
  engine_version         = var.engine_version
  allocated_storage      = 20
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.ecs_tier_rds_db_subnet_group.name
  vpc_security_group_ids = [var.database_sg_id]
  storage_encrypted      = true
  publicly_accessible    = false
  multi_az               = false
  port                   = 3306
  username               = var.db_username
  password               = random_password.ecs_create_db_password.result

  tags = {
    Name = "${var.project_name}-database"
  }
}