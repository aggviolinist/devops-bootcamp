variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
}
variable "private_subnet_ids" {
    description = "List of private subnet IDs"
    type        = list(string)
}
variable "container_sg_id" {
    description = "Security Group ID for the ECS containers"
    type        = string
}
variable "alb_target_group" {
    description = "ALB Target Group ARN"
    type        = string
}
variable "ecs_task_role" {
    description = "ECS Task Role ARN"
    type        = string
}
variable "ecs_task_execution_role" {
    description = "ECS Task Execution Role ARN"
    type        = string
}
variable "database_username" {
  description = "The master username for the database"
  type        = string
  sensitive = true
}
variable "database_password" {
    description = "The password of the database"
    type = string
    sensitive = true
}
variable "database_endpoint" {
    description = "The database endpoint"
    type = string
}