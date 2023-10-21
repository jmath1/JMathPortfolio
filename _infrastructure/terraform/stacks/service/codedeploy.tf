# resource "aws_codedeploy_app" "_" {
#   compute_platform = "ECS"
#   name             = local.name
# }

# resource "aws_iam_role" "code_deploy_role" {
#   name               = "code-deploy-role"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Effect": "Allow",
#       "Principal": {
#         "Service": "codedeploy.amazonaws.com"
#       },
#       "Action": "sts:AssumeRole"
#     }
#   ]
# }
# EOF
# }


# resource "aws_iam_policy" "ecs_policy" {
#   name        = "ECSPolicy"
#   description = "Allows full access to ecs"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "ecs:*",
#           "iam:PassRole",
#           "elasticloadbalancing:*"
#         ],
#         Resource = ["*"]
#       }
#     ]
#   })
# }

# resource "aws_iam_policy" "alb_policy" {
#   name        = "ALBPolicy"
#   description = "Allows Access to ALB"
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "elasticloadbalancing:Describe*",
#           "elasticloadbalancing:RegisterTargets",
#           "elasticloadbalancing:DeregisterTargets",
#         ],
#         Resource = ["*"]
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "ecs_attachment" {
#   role       = aws_iam_role.code_deploy_role.name
#   policy_arn = aws_iam_policy.ecs_policy.arn
# }

# resource "aws_iam_role_policy_attachment" "alb_attachment" {
#   role       = aws_iam_role.code_deploy_role.name
#   policy_arn = aws_iam_policy.alb_policy.arn
# }

# resource "aws_codedeploy_deployment_group" "_" {
#   depends_on             = [aws_codedeploy_app._]
#   app_name               = aws_codedeploy_app._.name
#   deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
#   deployment_group_name  = local.name
#   service_role_arn       = aws_iam_role.code_deploy_role.arn

#   auto_rollback_configuration {
#     enabled = true
#     events  = ["DEPLOYMENT_FAILURE"]
#   }

#   blue_green_deployment_config {
#     deployment_ready_option {
#       action_on_timeout = "CONTINUE_DEPLOYMENT"
#     }


#     terminate_blue_instances_on_deployment_success {
#       action = "TERMINATE"
#     }
#   }

#   deployment_style {
#     deployment_option = "WITH_TRAFFIC_CONTROL"
#     deployment_type   = "BLUE_GREEN"
#   }

#   ecs_service {
#     cluster_name = module.ecs_cluster.name
#     service_name = module.app.name
#   }

#   load_balancer_info {

#     target_group_pair_info {
#       prod_traffic_route {
#         listener_arns = module.alb.https_listener_arns
#       }
#       target_group {
#         name = module.alb.target_group_names[0]
#       }
#     }
#   }
# }