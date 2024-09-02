data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    key    = "prod/network.tfstate"
    region = "us-east-1"
    bucket = "jmath-terraform-state"
  }
}

data "terraform_remote_state" "domain" {
  backend = "s3"

  config = {
    key    = "prod/domain.tfstate"
    region = "us-east-1"
    bucket = "jmath-terraform-state"
  }
}