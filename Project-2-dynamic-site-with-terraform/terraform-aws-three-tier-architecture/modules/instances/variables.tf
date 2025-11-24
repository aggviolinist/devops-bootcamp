# Main details
variable "project_name" {
  description = "Name of the project for resource tagging from root"
  type        = string
}

# private Subnets
variable "private_subnets" {
  description = "List of subnets from network module from module network"
  type        = list(string)
}

# security groups
variable "eice_sg_id" {
  description = "Security group for the EC2 Instance Connection Endpoint from module security group"
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
#web_server sg 
variable "web_server_sg_id" {
  description = "The Web server security group from module security"
  type        = string
}
#IAM instance profile
variable "ec2instance_three_tier_instance_profile" {
  description = "Attach this instance to s3 and secrets manager permissions we need"
  type        = string
}