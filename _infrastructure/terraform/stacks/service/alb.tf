module "alb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = "${local.name}-service"
  description = "Service security group"
  vpc_id      = local.vpc_id

  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  ingress_cidr_blocks = ["0.0.0.0/0"]

  egress_rules       = ["all-all"]
  egress_cidr_blocks = local.private_subnet_cidrs

}


resource "aws_security_group" "http_access" {
  name        = "target-security-group"
  description = "Security group for the targets"

  vpc_id = local.vpc_id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [local.vpc_cidr]
  }

  tags = {
    Name = "HTTP Access"
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"

  name = "lb-${var.env}"

  load_balancer_type = "application"

  vpc_id          = local.vpc_id
  subnets         = local.public_subnets
  security_groups = [module.alb_sg.security_group_id, aws_security_group.http_access.id]

  preserve_host_header = true
  # access_logs = {
  #   enabled = true
    
  #   bucket  = "jmath-access-logs-${var.env}"
  #   prefix  = "alb"
  # }

  https_listeners = [
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = local.acm_certificate_arn
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  target_groups = [
    {
      name             = "django"
      backend_protocol = "HTTP"
      backend_port     = 8000
      target_type      = "ip"

      health_check = {
        protocol = "HTTP"
        enable   = true
        interval = 30
        path     = "/healthcheck"
        port     = 8000
        matcher  = 301
      }

    }
  ]

}

