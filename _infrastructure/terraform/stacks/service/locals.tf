locals {
  env                  = var.env == "production" ? "prod" : var.env
  name                 = "jmath-${local.env}"
  vpc_id               = data.terraform_remote_state.network.outputs.vpc_id
  vpc_cidr             = data.terraform_remote_state.network.outputs.vpc_cidr
  public_subnets       = data.terraform_remote_state.network.outputs.public_subnets
  private_subnets      = data.terraform_remote_state.network.outputs.private_subnets
  private_subnet_cidrs = data.terraform_remote_state.network.outputs.private_subnet_cidrs
  security_group_id    = data.terraform_remote_state.network.outputs.security_group_id
  azs                  = slice(data.aws_availability_zones.available.names, 0, 3)
  hosted_zone_id       = data.terraform_remote_state.domain.outputs.route53_zone.zone_id
  static_files_bucket  = data.terraform_remote_state.persistence.outputs.s3_bucket_name
  db_host              = data.terraform_remote_state.persistence.outputs.db_host_address
  django = {
    container_name = "portfolio"
    cpu            = 512
    memory         = 1024
    container_port = 8000
    image          = "${data.terraform_remote_state.registry.outputs.registry_url}:django"
    secrets = [
      for name, arn in data.terraform_remote_state.secrets.outputs.envs : {
        "name" : "${name}",
        "valueFrom" : "${arn}",
        "readOnly" : true
      }
    ]
    memory_reservation = 100
  }

  acm_certificate_arn = data.aws_acm_certificate._.arn

  security_group_rules = {
    alb_ingress_8000 = {
      type                     = "ingress"
      from_port                = local.django.container_port
      to_port                  = local.django.container_port
      protocol                 = "tcp"
      description              = "app"
      source_security_group_id = module.alb_sg.security_group_id
    }

    egress_all = {
      type        = "egress"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

}
