data "terraform_remote_state" "domain" {
  backend = "s3"

  config = {
    key    = "${var.env == "production" ? "prod" : var.env}/domain.tfstate"
    region = "us-east-1"
    bucket = "jmath-terraform-state"
  }
}
