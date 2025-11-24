# Security details
variable "github_oidc_url" {
  description = "The OpenID connect (OIDC) provider url for GitHub Actions."
  type        = string
  default     = "https://token.actions.githubusercontent.com"
}

variable "git_oidc_thumbprint_list" {
  description = "List of thumbprints for the GitHub OIDC provider."
  type        = list(string)
  default     = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}