#Policy to give EC2 tasks access to s3
resource "aws_iam_policy" "custom_policy_for_s3" {
  name        = "policy-s3"
  description = "Policy to give EC2 and ECS role access s3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListAllMyBuckets"
        ]
        Resource = "*"
      }
    ]
  })
}

#Policy to give EC2 and ECS task manager access to secrets manager
resource "aws_iam_policy" "custom_policy_for_secrets_manager" {
  name        = "policy-for-secrets-manager"
  description = "Policy to give EC2, ECS tasks and ECS task executor access to secrets manager"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*"
      }
    ]
  })
}

#Role to give EC2 tasks access to s3 and secrets manager
resource "aws_iam_role" "custom_role_for_ec2_policies" {
  name        = "ec2-role-policies"
  description = "Role to give EC2 access to secrets manager and s3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Role for ECS TASK ROLE to secrets manager
resource "aws_iam_role" "custom_role_for_ecs_task_policies" {
  name        = "ecs-task-role"
  description = "Role to give ECS tasks role access to secrets manager,s3,ssm"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#Role for ECS TASK AGENT to secrets manager
resource "aws_iam_role" "custom_role_for_ecs_task_execution_policies" {
  name        = "ecs-task-execution-role"
  description = "Role to give ECS agent access to ssm,secrets manager,cloudwatch logs and ecr"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

#ec2role policy attachments
resource "aws_iam_role_policy_attachment" "attach_s3_policy_to_ec2_role" {
  role       = aws_iam_role.custom_role_for_ec2_policies.name
  policy_arn = aws_iam_policy.custom_policy_for_s3.arn
}
resource "aws_iam_role_policy_attachment" "attach_secrets_manager_policy_to_ec2_role" {
  role       = aws_iam_role.custom_role_for_ec2_policies.name
  policy_arn = aws_iam_policy.custom_policy_for_secrets_manager.arn
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.custom_role_for_ec2_policies.name
}

#ecs task execution role policy attachments
resource "aws_iam_role_policy_attachment" "attach_secret_manager_policy_to_ecs_task_role" {
  role       = aws_iam_role.custom_role_for_ecs_task_policies.name
  policy_arn = aws_iam_policy.custom_policy_for_secrets_manager.arn
}
resource "aws_iam_role_policy_attachment" "attach_s3_policies_to_ecs_task_role" {
  role       = aws_iam_role.custom_role_for_ecs_task_policies.name
  policy_arn = aws_iam_policy.custom_policy_for_s3.arn
}
resource "aws_iam_role_policy_attachment" "attach_ssm_full_access_to_ecs_task_role" {
  role       = aws_iam_role.custom_role_for_ecs_task_policies.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
}

#ecs task execution role policy attachments
resource "aws_iam_role_policy_attachment" "attach_ecr_to_ecs_task_execution_role" {
  role       = aws_iam_role.custom_role_for_ecs_task_execution_policies.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_iam_role_policy_attachment" "attach_secret_manager_policy_to_ecs_task_execution_role" {
  role       = aws_iam_role.custom_role_for_ecs_task_execution_policies.name
  policy_arn = aws_iam_policy.custom_policy_for_secrets_manager.arn
}
resource "aws_iam_role_policy_attachment" "attach_cloudwatch_logs_to_ecs_task_execution_role" {
  role       = aws_iam_role.custom_role_for_ecs_task_execution_policies.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}