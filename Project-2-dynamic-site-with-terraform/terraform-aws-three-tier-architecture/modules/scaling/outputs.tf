output "scale_up_autoscaling_policy" {
  value = aws_autoscaling_policy.scale_up.arn
}
output "scale_down_autoscaling_policy" {
  value = aws_autoscaling_policy.scale_down.arn
}
output "three_tier_asg" {
  value = aws_autoscaling_group.three_tier_asg.name
}