#Create the ECS Service
resource "aws_ecs_service" "nest_app_ecs_service" {
    name = "${var.project_name}-ecs-service"
    cluster = aws_ecs_cluster.nest_app_cluster.id
    task_definition = aws_ecs_task_definition.nest_app_task.arn
    desired_count = 2
    launch_type = "FARGATE"
    deployment_minimum_healthy_percent = 50
    deployment_maximum_percent = 200

    network_configuration {
        subnets = var.private_subnet_ids
        security_groups = [var.container_sg_id]
        assign_public_ip = false        
    }
    load_balancer {
        target_group_arn = var.alb_target_group
        container_name   = "nest-app"
        container_port   = 3000
    }
    depends_on = [ aws_ecs_task_definition.nest_app_task ]
}
#Create the task definition for ECS Service
resource "aws_ecs_task_definition" "nest_app_task" {
    family = "${var.project_name}-nest-app-task"
    network_mode = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu = "256"
    memory = "512"
    execution_role_arn = var.ecs_task_execution_role
    task_role_arn = var.ecs_task_role

    container_definitions = jsonencode([
        {
            name = "nest-app"
            image = "*********************************************"
            cpu = 256
            memory = 512
            essential = true
            portMappings = [
                {
                    containerPort = 3000
                    protocol      = "tcp"
                }
            ]
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    "awslogs-group"         = "/ecs/${var.project_name}-nest-app-logs"
                    "awslogs-region"        = "us-east-1"
                    "awslogs-stream-prefix" = "ecs"
                }

            }
            
            environment = [
                {
                name  = "DB_HOST"
                value = var.database_endpoint

                }
            ]

            secrets = [ 
                {
                name = "DATABASE_USERNAME"
                valueFrom  = var.database_username

                },
                {
                name = "DATABASE_PASSWORD"
                valueFrom = var.database_password
                }
            ]
        }
    ])
}

resource "aws_cloudwatch_log_group" "nest_app_logs" {
    name              = "/ecs/${var.project_name}-nest-app-logs"
    retention_in_days = 7 
}
#Create Cluster for ECS Service
resource "aws_ecs_cluster" "nest_app_cluster" {
  name = "${var.project_name}-ecs-cluster"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}