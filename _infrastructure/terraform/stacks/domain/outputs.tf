#output "acm_cert_validation" {
#    value = aws_acm_certificate._.domain_validation_options
#}

output "acm_cert_arn" {
  value = aws_acm_certificate._.arn
}

output "acm_cert_status" {
  value = aws_acm_certificate._.status
}

output "route53_zone" {
  value = aws_route53_zone.jonathanmath_com
}

output "name_servers" {
  value = aws_route53_zone.jonathanmath_com.name_servers
}

