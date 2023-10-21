data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    key    = "${local.env}/network.tfstate"
    region = "us-east-1"
    bucket = "jmath-terraform-state"
  }
}

data "terraform_remote_state" "domain" {
  backend = "s3"

  config = {
    key    = "${local.env}/domain.tfstate"
    region = "us-east-1"
    bucket = "jmath-terraform-state"
  }
}


data "terraform_remote_state" "registry" {
  backend = "s3"

  config = {
    key    = "${local.env}/registry.tfstate"
    region = "us-east-1"
    bucket = "jmath-terraform-state"
  }
}

data "terraform_remote_state" "persistence" {
  backend = "s3"

  config = {
    key    = "${local.env}/persistence.tfstate"
    region = "us-east-1"
    bucket = "jmath-terraform-state"
  }
}


data "terraform_remote_state" "secrets" {
  backend = "s3"

  config = {
    key    = "${local.env}/secrets.tfstate"
    region = "us-east-1"
    bucket = "jmath-terraform-state"
  }
}