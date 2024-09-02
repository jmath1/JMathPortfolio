locals {
  hosted_zone_id = data.terraform_remote_state.domain.outputs.route53_zone.zone_id
  hosted_zone_name = data.terraform_remote_state.domain.outputs.route53_zone.name
  vpc_default_security_group_id = data.terraform_remote_state.network.outputs.security_group_id
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_id = data.terraform_remote_state.network.outputs.public_subnet_id
}