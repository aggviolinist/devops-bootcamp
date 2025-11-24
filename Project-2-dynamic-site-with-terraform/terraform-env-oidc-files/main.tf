module "Security" {
  source                   = "./modules/security"
  github_oidc_url          = var.github_oidc_url
  git_oidc_thumbprint_list = var.git_oidc_thumbprint_list
}