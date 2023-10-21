output "task_exec_iam_role_arn" {
  value = module.app.task_exec_iam_role_arn
}

output "task_exec_iam_role_name" {
  value = module.app.task_exec_iam_role_name
}


output "alb_target_group_arns" {
  value = module.alb.target_group_arns
}

output "alb_dns_name" {
  value = module.alb.lb_dns_name
}

output "alb_listener_arn" {
  value = module.alb.https_listener_arns[0]
}

output "alb_zone_id" {
  value = module.alb.lb_zone_id
}

# output "task_definition_arn" {
#   value = data.aws_ecs_task_definition.latest.arn
# }