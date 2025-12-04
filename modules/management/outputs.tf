output "ec2_instance_profile" {
  value = aws_iam_instance_profile.ec2_instance_profile.name
}

output "ecs_task_role" {
  value = aws_iam_role.custom_role_for_ecs_task_policies.arn
}

output "ecs_task_execution_role" {
  value = aws_iam_role.custom_role_for_ecs_task_execution_policies.arn
}