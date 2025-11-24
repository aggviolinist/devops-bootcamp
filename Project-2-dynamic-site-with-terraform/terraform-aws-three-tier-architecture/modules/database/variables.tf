variable "project_name" {
  description = "Name of the project for resource tagging"
  type        = string
}
# private Subnets
variable "private_subnets" {
  description = "List of subnets from network module from module network"
  type        = list(string)
}
variable "rds_sg_id" {
  description = "Security group of the DB"
  type        = string
}
#DB Instance class
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
  description = "The username of DB"
  type        = string
  sensitive   = true
}