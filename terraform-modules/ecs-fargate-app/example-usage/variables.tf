variable "aws_region" {
  description = "AWS region for the provider."
  type        = string
}

variable "service_name" {
  description = "Backstage serviceName."
  type        = string
}

variable "description" {
  description = "Service description."
  type        = string
  default     = null
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "owner" {
  description = "Backstage owner value."
  type        = string
  default     = null
}

variable "cpu" {
  description = "Fargate CPU units."
  type        = string
}

variable "memory" {
  description = "Fargate memory in MiB."
  type        = string
}

variable "port" {
  description = "Container port."
  type        = number
}

variable "health_check_path" {
  description = "ALB health check path."
  type        = string
  default     = "/health"
}

variable "desired_count" {
  description = "Desired ECS task count."
  type        = number
  default     = 1
}

variable "cluster" {
  description = "ECS cluster name or ARN."
  type        = string
}

variable "container_image" {
  description = "Container image URI."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for ECS tasks."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs for ECS tasks."
  type        = list(string)
}

variable "alb_listener_arn" {
  description = "Existing ALB listener ARN. Leave null to create a new listener."
  type        = string
  default     = null
}

variable "listener_rule_priority" {
  description = "ALB listener rule priority when using an existing listener."
  type        = number
  default     = null
}

variable "load_balancer_arn" {
  description = "ALB ARN used when creating a new listener."
  type        = string
  default     = null
}

variable "listener_port" {
  description = "Port for a new listener."
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol for a new listener."
  type        = string
  default     = "HTTP"
}

variable "certificate_arn" {
  description = "ACM certificate ARN for a new HTTPS listener."
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "SSL policy for a new HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "host_header" {
  description = "Optional ALB host header rule."
  type        = string
  default     = null
}

variable "path_patterns" {
  description = "ALB path patterns."
  type        = list(string)
  default     = ["/*"]
}

variable "assign_public_ip" {
  description = "Assign a public IP to ECS tasks."
  type        = bool
  default     = false
}

variable "platform_version" {
  description = "Fargate platform version."
  type        = string
  default     = "LATEST"
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention in days."
  type        = number
  default     = 30
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum healthy percent during deployment."
  type        = number
  default     = 100
}

variable "deployment_maximum_percent" {
  description = "Maximum percent during deployment."
  type        = number
  default     = 200
}

variable "task_role_policy_json" {
  description = "Optional inline policy JSON for the task role."
  type        = string
  default     = null
}

variable "ssm_paths" {
  description = "SSM Parameter Store paths."
  type        = list(string)
  default     = []
}

variable "secrets_manager_arns" {
  description = "Secrets Manager ARNs."
  type        = list(string)
  default     = []
}

variable "environment_variables" {
  description = "Container environment variables."
  type        = map(string)
  default     = {}
}

variable "enable_execute_command" {
  description = "Enable ECS Exec."
  type        = bool
  default     = true
}

variable "enable_autoscaling" {
  description = "Enable ECS service autoscaling."
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "Autoscaling minimum capacity."
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Autoscaling maximum capacity."
  type        = number
  default     = 4
}

variable "autoscaling_cpu_target" {
  description = "CPU utilization target."
  type        = number
  default     = 70
}

variable "autoscaling_memory_target" {
  description = "Memory utilization target."
  type        = number
  default     = 75
}

variable "target_group_deregistration_delay" {
  description = "Target group deregistration delay."
  type        = number
  default     = 30
}

variable "health_check_grace_period_seconds" {
  description = "ECS health check grace period."
  type        = number
  default     = 60
}

variable "tags" {
  description = "Additional resource tags."
  type        = map(string)
  default     = {}
}
