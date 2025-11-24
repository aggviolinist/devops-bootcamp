variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
}
variable "vpc_id" {
  description = "Our VPC"
  type        = string
}
variable "alb_sg_id" {
  description = "Our ALB security group from our security group module"
  type        = string
}
variable "public_subnets" {
  description = "Our ALB subnet from our network module"
  type        = list(string)
}