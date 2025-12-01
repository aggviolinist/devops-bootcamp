#Create the ECS Service
resource "aws_ecs_service" "nest_app_ecs_service" {
  name                               = "${var.project_name}-ecs-service"
  cluster                            = aws_ecs_cluster.nest_app_cluster.id
  task_definition                    = aws_ecs_task_definition.nest_app_task.arn
  desired_count                      = 2
  launch_type                        = "FARGATE"
  platform_version = "1.4.0"
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  network_configuration {
    subnets          = var.private_subnet_ids
    security_groups  = [var.container_sg_id]
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = var.alb_target_group
    container_name   = "shopwise-app"
    container_port   = 80
  }
  depends_on = [aws_ecs_task_definition.nest_app_task]
}
#Create the task definition for ECS Service
resource "aws_ecs_task_definition" "nest_app_task" {
  family                   = "${var.project_name}-shopwise-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_task_execution_role
  task_role_arn            = var.ecs_task_role

  container_definitions = jsonencode([
    {
      name      = "shopwise-app"
      image     = "${var.ecr_repo}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.project_name}-shopwise-app-logs"
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }

      }

      environment = [
        {
          name  = "APP_NAME"
          value = "Your App"
        },
        {
          name  = "APP_ENV"
          value = "production"
        },
        {
          name  = "APP_DEBUG"
          value = "false"
        },
        {
          name  = "APP_KEY"
          value = "base64:SbzM2tzPsCSlpTEdyaju8l9w2C5vmtd4fNAduiLEqng="
        },
        {
          name  = "APP_URL"
          value = "http://${var.alb_dns_name}"
        },
        {
          name  = "LOG_CHANNEL"
          value = "daily"
        },
        {
          name  = "DB_CONNECTION"
          value = "mysql"
        },
        {
          name  = "DB_HOST"
          value = var.database_endpoint

        },
        {
          name  = "DB_DATABASE"
          value = var.database_name
        },
        {
          name  = "DB_PORT"
          value = "3306"
        },
        {
          name  = "CACHE_DRIVER"
          value = "file"
        },
        {
          name  = "QUEUE_CONNECTION"
          value = "sync"
        },
        {
          name  = "SESSION_DRIVER"
          value = "file"
        },
        {
          name  = "ADMIN_DIR"
          value = "admin"
        }
      ]

      secrets = [
        {
          name      = "DB_USERNAME"
          valueFrom = "${var.database_secret_arn}:username"

        },
        {
          name      = "DB_PASSWORD"
          valueFrom = "${var.database_secret_arn}:password"
        }
      ]
    }
  ])
}

resource "aws_cloudwatch_log_group" "nest_app_logs" {
  name              = "/ecs/${var.project_name}-shopwise-app-logs"
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