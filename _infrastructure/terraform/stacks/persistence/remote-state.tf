data "terraform_remote_state" "domain" {
  backend = "s3"

  config = {
    key    = "${var.env == "production" ? "prod" : var.env}/domain.tfstate"
    region = "us-east-1"
    bucket = "jmath-terraform-state"
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    key    = "${var.env == "production" ? "prod" : var.env}/network.tfstate"
    region = "us-east-1"
    bucket = "jmath-terraform-state"
  }
}

data "terraform_remote_state" "secrets" {
  backend = "s3"

  config = {
    key    = "${var.env == "production" ? "prod" : var.env}/secrets.tfstate"
    region = "us-east-1"
    bucket = "jmath-terraform-state"
  }
}
