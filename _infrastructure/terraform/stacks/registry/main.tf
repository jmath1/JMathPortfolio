resource "aws_ecr_repository" "_" {
  name                 = "jmath-registry"
  image_tag_mutability = "MUTABLE"
}

data "aws_iam_policy_document" "root_allow" {
  statement {
    sid    = "ECR-Access"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = var.trusted_accounts
    }

    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
  }
}

data "aws_iam_openid_connect_provider" "github_runner_provider" {
  url = "https://token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "github_allow" {
  statement {
    effect = "Allow"
    principals {
      type        = "Federated"
      identifiers = [data.aws_iam_openid_connect_provider.github_runner_provider.arn]
    }
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:DescribeRepositories",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages",
      "ecr:DeleteRepository",
      "ecr:BatchDeleteImage",
      "ecr:SetRepositoryPolicy",
      "ecr:DeleteRepositoryPolicy",
    ]
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repository_owner}/${var.github_repository_repo}:*"]

    }
  }
}

resource "aws_ecr_repository_policy" "root" {
  repository = aws_ecr_repository._.name
  policy     = data.aws_iam_policy_document.root_allow.json
}

resource "aws_ecr_repository_policy" "github" {
  repository = aws_ecr_repository._.name
  policy     = data.aws_iam_policy_document.github_allow.json
}
