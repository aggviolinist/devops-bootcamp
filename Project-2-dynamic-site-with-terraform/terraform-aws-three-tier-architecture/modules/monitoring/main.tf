resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project_name}-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUTILIZATION"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = 70

  dimensions = {
    autoscaling_group_name = var.three_tier_asg
  }
  alarm_actions = [var.scale_up_autoscaling_policy]
}
resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "${var.project_name}-cpu-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUTILIZATON"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = 30

  dimensions = {
    autoscaling_group_name = var.three_tier_asg
  }
  alarm_actions = [var.scale_up_autoscaling_policy]
}