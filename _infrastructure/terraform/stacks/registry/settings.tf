terraform {
  backend "s3" {
    bucket = "jmath-terraform-state"
    region = "us-east-1"
  }
}
