output "alb_target_group" {
  value = aws_alb_target_group.ecs_three_tier_target_group.arn
}
output "alb_dns_name" {
  value = aws_alb.ecs_three_tier_elb.dns_name
}