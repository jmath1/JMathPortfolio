resource "aws_route53_record" "app_service_record" {
  zone_id = local.hosted_zone_id
  name    = var.env == "production" ? "jonathanmath.com" : "${var.env}.jonathanmath.com"
  type    = "A"
  alias {
    name                   = module.alb.lb_dns_name
    zone_id                = module.alb.lb_zone_id
    evaluate_target_health = true
  }
}