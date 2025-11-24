variable "project_name" {
  description = "Name of the project for resource tagging from root"
  type        = string
}
variable "scale_up_autoscaling_policy" {
  description = "Name of the scale up policy from module scaling"
  type        = string
}
variable "scale_down_autoscaling_policy" {
  description = "Name of the scale up policy from module scaling"
  type        = string
}
variable "three_tier_asg" {
  description = "three tier ASG"
  type        = string
}
