module "app" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name        = "${local.name}-service"
  cluster_arn = module.ecs_cluster.arn

  cpu    = 1024
  memory = 4096

  enable_execute_command = true
  create_tasks_iam_role  = false

  tasks_iam_role_arn    = aws_iam_role.task_role.arn
  container_definitions = {
    "portfolio" = {
      readonly_root_filesystem = false
      cpu                      = local.django.cpu
      memory                   = local.django.memory
      essential                = true
      image                    = local.django.image

      port_mappings = [
        {
          name          = local.django.container_name
          containerPort = local.django.container_port
          hostPort      = local.django.container_port
          protocol      = "tcp"
        }
      ]

      memory_reservation = local.django.memory_reservation
      secrets            = local.django.secrets
      environment        = [{
        "name": "snsEmailTopic",
        "value": aws_sns_topic.contact_form_topic.arn
      },
      {
        "name": "FARGATE_TASK",
        "value": "True"
      },
      {
        "name": "VPC_CIDR",
        "value": local.vpc_cidr
      },
      {
        "name": "LOAD_BALANCER_DNS_NAME",
        "value": module.alb.lb_dns_name
      },
      {
        "name": "DB_HOST",
        "value": local.db_host
      }]
    }
  }

  load_balancer = {
    app = {
      target_group_arn = element(module.alb.target_group_arns, 0)
      container_name   = local.django.container_name
      container_port   = local.django.container_port
    }
  }

  subnet_ids           = local.private_subnets
  security_group_rules = local.security_group_rules

}