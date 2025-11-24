resource "aws_iam_openid_connect_provider" "github_open_id_resource" {
  url             = var.github_oidc_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = var.git_oidc_thumbprint_list
}
