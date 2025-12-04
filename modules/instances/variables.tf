# Main details
variable "project_name" {
  description = "Name of the project for resource tagging from root"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "eice_ssh_sg_id" {
  description = "Security Group ID for SSH access"
  type        = string
}

variable "container_sg_id" {
  description = "Security Group ID for container instances"
  type        = string
}

variable "ec2_instance_profile" {
  description = "IAM Instance Profile for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "EC2 Instance Type for container instances"
  type        = string
}