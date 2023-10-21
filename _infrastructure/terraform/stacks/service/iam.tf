data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    sid    = "ECSTasksAssumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [var.account_id]
    }
    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:ecs:us-east-1:${var.account_id}:*"]
    }
  }
}
resource "aws_iam_role" "task_role" {
  name = "ecs-task-role"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json
}

resource "aws_iam_policy" "ecs_container_execution_policy" {
  name = "ContainerExecutionPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowECSContainerExecution"
        Effect = "Allow"
        Action = [
          "ecs:ExecuteCommand",
          "ecs:DescribeContainerInstances",
          "ecs:ListTasks",
          "ecs:DescribeTasks",
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "container_execution_policy_attachment" {
  role       = aws_iam_role.task_role.name
  policy_arn = aws_iam_policy.ecs_container_execution_policy.arn
}

