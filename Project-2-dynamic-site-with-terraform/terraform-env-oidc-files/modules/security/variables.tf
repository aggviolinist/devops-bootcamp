# Security details
variable "github_oidc_url" {
  description = "The OpenID connect (OIDC) provider url for GitHub Actions."
  type        = string
}

variable "git_oidc_thumbprint_list" {
  description = "List of thumbprints for the GitHub OIDC provider."
  type        = list(string)
}