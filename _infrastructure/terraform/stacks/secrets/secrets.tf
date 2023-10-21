resource "aws_secretsmanager_secret" "secrets" {
  for_each = local.envs

  name = each.key

}

resource "aws_secretsmanager_secret_version" "secrets" {
  for_each = local.envs

  secret_id     = aws_secretsmanager_secret.secrets[each.key].id
  secret_string = each.value

}

