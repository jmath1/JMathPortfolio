output "envs" {
  value = zipmap(
      [for x in aws_secretsmanager_secret.secrets : x.name],
      [for x in aws_secretsmanager_secret.secrets : x.arn],
    )
}