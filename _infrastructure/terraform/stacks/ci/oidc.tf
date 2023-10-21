resource "aws_iam_openid_connect_provider" "github_runner_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["${var.github_thumbprint}"]

  url = "https://token.actions.githubusercontent.com"
}