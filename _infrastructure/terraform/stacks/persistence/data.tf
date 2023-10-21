data "aws_secretsmanager_secret_version" "postgres_db" {
  secret_id = data.terraform_remote_state.secrets.outputs.envs.POSTGRES_DB
}

data "aws_secretsmanager_secret_version" "postgres_user" {
  secret_id = data.terraform_remote_state.secrets.outputs.envs.POSTGRES_USER
}

data "aws_secretsmanager_secret_version" "postgres_password" {
  secret_id =data.terraform_remote_state.secrets.outputs.envs.POSTGRES_PASSWORD
}