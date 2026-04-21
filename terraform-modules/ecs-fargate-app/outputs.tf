output "service_name" {
  description = "ECS service name."
  value       = aws_ecs_service.this.name
}

output "service_arn" {
  description = "ECS service ARN."
  value       = aws_ecs_service.this.id
}

output "task_definition_arn" {
  description = "Task definition ARN currently managed by the module."
  value       = aws_ecs_task_definition.this.arn
}

output "target_group_arn" {
  description = "ALB target group ARN."
  value       = aws_lb_target_group.this.arn
}

output "listener_rule_arn" {
  description = "ALB listener rule ARN when an existing listener is used."
  value       = try(aws_lb_listener_rule.this[0].arn, null)
}

output "listener_arn" {
  description = "ALB listener ARN, either provided externally or created by this module."
  value       = var.alb_listener_arn != null ? var.alb_listener_arn : aws_lb_listener.this[0].arn
}

output "log_group_name" {
  description = "CloudWatch log group name."
  value       = aws_cloudwatch_log_group.this.name
}

output "execution_role_arn" {
  description = "Task execution role ARN."
  value       = aws_iam_role.execution.arn
}

output "task_role_arn" {
  description = "Application task role ARN."
  value       = aws_iam_role.task.arn
}
