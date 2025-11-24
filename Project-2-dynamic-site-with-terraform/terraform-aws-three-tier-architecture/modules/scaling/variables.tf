variable "project_name" {
  description = "Name of the project for resource tagging from root"
  type        = string
}
#instance ami
variable "ami" {
  description = "Image for my instance from root"
  type        = string
}

#instance type
variable "instance_type" {
  description = "The Instance type gotten from root"
  type        = string
}
variable "web_server_sg_id" {
  description = "The Web server security group from module security"
  type        = string
}
variable "ec2instance_three_tier_instance_profile" {
  description = "This profile gives the ec2 instance s3 and secrets manager permission "
  type        = string
}
variable "private_subnets" {
  description = "List of subnets from network module from module network"
  type        = list(string)
}
variable "alb_target_group" {
  description = "ALB target group from module traffic"
  type        = string

}