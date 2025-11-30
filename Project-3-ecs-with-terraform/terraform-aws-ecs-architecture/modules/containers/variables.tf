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
variable "database_secret_arn" {
  description = "The master username for the database"
  type        = string
  sensitive   = true
}
variable "database_endpoint" {
  description = "The database endpoint"
  type        = string
}
variable "database_name" {
  description = "This is the database name"
  type        = string
}
variable "ecr_repo" {
  description = "The ECR repo for our project"
  type        = string
}