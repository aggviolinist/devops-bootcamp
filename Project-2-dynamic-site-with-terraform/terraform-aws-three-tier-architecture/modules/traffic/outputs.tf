output "alb_target_group" {
  value = aws_alb_target_group.three_tier_target_group_alb.arn
}