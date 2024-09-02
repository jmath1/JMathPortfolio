variable "env" {
  type = string
}
variable "account_number" {
  type = string
}

variable "trusted_accounts" {
  default = []
}

variable "github_repository_owner" {
  type = string
}

variable "github_repository_repo" {
  type = string
}