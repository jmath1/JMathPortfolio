data "aws_availability_zones" "available" {}

data "aws_acm_certificate" "_" {
  domain = var.env == "production" ? "jonathanmath.com" : "*.${var.env}.jonathanmath.com"
}

# data "aws_ecs_task_definition" "latest" {
#   task_definition = "jmath-${var.env}"
# }