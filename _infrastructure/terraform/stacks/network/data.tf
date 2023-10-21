data "aws_availability_zones" "available" {}

data "aws_acm_certificate" "_" {
  domain = var.env == "production" ? "jonathanmath.com" : "*.${var.env}.jonathanmath.com"
}