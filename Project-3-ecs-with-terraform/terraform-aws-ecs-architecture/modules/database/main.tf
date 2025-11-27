resource ""


resource "aws_db_instance" "ecs_tier_rds_database" {
    identifier = "${var.project_name}-db"
    db_name = var.db_name
    instance_class = var.instance_class
    engine = var.engine
    engine_version = var.engine_version
    allocated_storage = 20
    skip_final_snapshot = true
    db_subnet_group_name = ****************
    vpc_security_group_ids = [var.database_sg_id] database_sg_id
    storage_encrypted = true
    publicly_accessible = false
    multi_az = false
    port = 3306
    username = var.db_username
    password = ***************

    tags = {
        Name = "${var.project_name}-database"
    }
}