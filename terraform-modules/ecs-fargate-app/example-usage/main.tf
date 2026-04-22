module "ecs_fargate_app" {
  source = "../"

  service_name = var.service_name
  description  = var.description
  environment  = var.environment
  owner        = var.owner

  cpu               = var.cpu
  memory            = var.memory
  port              = var.port
  health_check_path = var.health_check_path
  desired_count     = var.desired_count
  cluster           = var.cluster

  container_image        = var.container_image
  vpc_id                 = var.vpc_id
  subnet_ids             = var.subnet_ids
  security_group_ids     = var.security_group_ids
  alb_listener_arn       = var.alb_listener_arn
  listener_rule_priority = var.listener_rule_priority
  load_balancer_arn      = var.load_balancer_arn
  listener_port          = var.listener_port
  listener_protocol      = var.listener_protocol
  certificate_arn        = var.certificate_arn
  ssl_policy             = var.ssl_policy
  host_header            = var.host_header
  path_patterns          = var.path_patterns

  assign_public_ip                   = var.assign_public_ip
  platform_version                   = var.platform_version
  log_retention_in_days              = var.log_retention_in_days
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent
  task_role_policy_json              = var.task_role_policy_json
  ssm_paths                          = var.ssm_paths
  secrets_manager_arns               = var.secrets_manager_arns
  environment_variables              = var.environment_variables
  enable_execute_command             = var.enable_execute_command
  enable_autoscaling                 = var.enable_autoscaling
  autoscaling_min_capacity           = var.autoscaling_min_capacity
  autoscaling_max_capacity           = var.autoscaling_max_capacity
  autoscaling_cpu_target             = var.autoscaling_cpu_target
  autoscaling_memory_target          = var.autoscaling_memory_target
  target_group_deregistration_delay  = var.target_group_deregistration_delay
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  tags                               = var.tags
}

output "service_name" {
  value = module.ecs_fargate_app.service_name
}

output "service_arn" {
  value = module.ecs_fargate_app.service_arn
}

output "task_definition_arn" {
  value = module.ecs_fargate_app.task_definition_arn
}

output "target_group_arn" {
  value = module.ecs_fargate_app.target_group_arn
}

output "listener_rule_arn" {
  value = module.ecs_fargate_app.listener_rule_arn
}

output "listener_arn" {
  value = module.ecs_fargate_app.listener_arn
}
