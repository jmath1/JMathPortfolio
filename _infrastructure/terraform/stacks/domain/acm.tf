resource "aws_acm_certificate" "_" {
  domain_name       = var.env == "production" ? "jonathanmath.com" : "*.${var.env}.jonathanmath.com"
  validation_method = "DNS"
}