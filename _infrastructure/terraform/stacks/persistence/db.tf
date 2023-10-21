module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.name

  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14"
  major_engine_version = "14"
  instance_class       = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 20

  db_name  = data.aws_secretsmanager_secret_version.postgres_db.secret_string
  username = data.aws_secretsmanager_secret_version.postgres_user.secret_string
  password = data.aws_secretsmanager_secret_version.postgres_password.secret_string

  manage_master_user_password = false
  storage_encrypted = false
  port              = 5432

  multi_az               = false
  db_subnet_group_name   = data.terraform_remote_state.network.outputs.database_subnet_group_name
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = false

}


module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = var.name
  description = "Postgres security group"
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = data.terraform_remote_state.network.outputs.vpc_cidr
    },
  ]

}