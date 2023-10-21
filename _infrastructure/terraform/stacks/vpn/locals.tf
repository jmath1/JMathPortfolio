locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnet_cidrs = data.terraform_remote_state.network.outputs.public_subnet_cidrs

  vpc_default_security_group_id = data.terraform_remote_state.network.outputs.security_group_id
  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  public_subnet_id = data.terraform_remote_state.network.outputs.public_subnet_id
}