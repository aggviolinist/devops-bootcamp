# Main details
variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
}

# Network
variable "vpc_cidr" {
  description = "VPC CIDR value"
  type        = string
}

#Instance_ami
variable "ami" {
  description = "Image for my instance"
  type        = string
}
#Instace_type
variable "instance_type" {
  description = "The Instance type gotten from root"
  type        = string
}
#Database Instance Class
variable "instance_class" {
  description = "The Database Instance class gotten from root"
  type        = string
}
variable "engine" {
  description = "The Database engine gotten from root"
  type        = string
}
variable "engine_version" {
  description = "The Database engine version gotten from root"
  type        = string
}
variable "db_name" {
  description = "The name of the Database gotten from root"
  type        = string
}

variable "db_username" {
  description = "The name of the DB username gotten from root"
  type        = string
  sensitive   = true
}

