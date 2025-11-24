output "github_oidc_arn" {
  description = "Arn value of github oidc"
  value       = aws_iam_openid_connect_provider.github_open_id_resource.arn
}