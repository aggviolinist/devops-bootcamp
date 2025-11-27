variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
}

variable "alb_server_sg_id" {
  description = "ALB Security Group ID"
  type        = string
}

variable "public_subnets" {
  description = "List of public subnet IDs"
  type        = list(string)
}
