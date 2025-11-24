resource "aws_iam_policy" "custom_policy_for_s3_secrets_manager" {
  name        = "three-tier-policy-s3-secrets-manager"
  description = "Policy to give EC2 instance full access to secrets manager and s3"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListAllMyBuckets",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "custom_role_for_s3_secrets_manager" {
  name        = "three-tier-role-s3-secrets-manager"
  description = "Role to give EC2 instance full access to secrets manager and s3"

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
    }
  )
}
resource "aws_iam_role_policy_attachment" "policy_and_role_attachment" {
  role       = aws_iam_role.custom_role_for_s3_secrets_manager.name
  policy_arn = aws_iam_policy.custom_policy_for_s3_secrets_manager.arn
}

resource "aws_iam_instance_profile" "three_tier_instance_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.custom_role_for_s3_secrets_manager.name
}