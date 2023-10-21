data "aws_iam_policy_document" "github_allow" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_runner_provider.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:${var.github_repository_owner}/${var.github_repository_repo}:*"]

    }
  }
}

resource "aws_iam_role" "github_runner_role" {
  name = "github-runner-role"

  assume_role_policy = data.aws_iam_policy_document.github_allow.json
}


resource "aws_s3_bucket_policy" "github_runner_s3_policy" {
  bucket   = local.bucket_name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { AWS = aws_iam_role.github_runner_role.arn }
        Action    = "s3:*"
        Resource = [
          "arn:aws:s3:::${local.bucket_name}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_policy" {
  name        = "ECRPolicy"
  description = "Allows full access to ECR"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "ECRPermissions"
        Effect = "Allow",
        Action = ["ecr:*"
        ],
        Resource = [
          "*"
        ]
      }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "assume_role_attachment" {
  role       = aws_iam_role.github_runner_role.name
  policy_arn = aws_iam_policy.assume_role_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecr_policy_attachment" {
  role       = aws_iam_role.github_runner_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}

resource "aws_iam_policy" "assume_role_policy" {
  name   = "AssumeRolePolicy"
  policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:*"
    ]

    resources = [
      "*"
    ]
  }
}