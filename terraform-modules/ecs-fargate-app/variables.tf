variable "service_name" {
  description = "Backstage serviceName. Used for ECS family, service naming, and tagging."
  type        = string
}

variable "description" {
  description = "Backstage description for the application."
  type        = string
  default     = null
}

variable "environment" {
  description = "Backstage environment selector such as dev, staging, or production."
  type        = string
}

variable "owner" {
  description = "Backstage owner value used in resource tags."
  type        = string
  default     = null
}

variable "cpu" {
  description = "Backstage cpu input for the Fargate task definition."
  type        = string
}

variable "memory" {
  description = "Backstage memory input in MiB for the Fargate task definition."
  type        = string
}

variable "port" {
  description = "Backstage container port."
  type        = number
}

variable "health_check_path" {
  description = "Backstage healthCheckPath used by the target group."
  type        = string
  default     = "/health"
}

variable "desired_count" {
  description = "Backstage desiredCount for the ECS service."
  type        = number
  default     = 1
}

variable "cluster" {
  description = "Target ECS cluster name or ARN. Mirrors the optional Backstage cluster field."
  type        = string
}

variable "container_image" {
  description = "Fully qualified container image URI to deploy."
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the ALB target group and ECS service should run."
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for ECS tasks."
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups attached to the ECS tasks."
  type        = list(string)
}

variable "alb_listener_arn" {
  description = "Existing ALB listener ARN used to route traffic to the service. If null, the module creates a new listener."
  type        = string
  default     = null
}

variable "listener_rule_priority" {
  description = "Unique listener rule priority when attaching to an existing ALB listener."
  type        = number
  default     = null
}

variable "load_balancer_arn" {
  description = "ALB ARN used when the module needs to create a new listener."
  type        = string
  default     = null
}

variable "listener_port" {
  description = "Port for a newly created listener."
  type        = number
  default     = 80
}

variable "listener_protocol" {
  description = "Protocol for a newly created listener. Use HTTP or HTTPS."
  type        = string
  default     = "HTTP"
}

variable "certificate_arn" {
  description = "ACM certificate ARN required when creating an HTTPS listener."
  type        = string
  default     = null
}

variable "ssl_policy" {
  description = "SSL policy for a newly created HTTPS listener."
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "host_header" {
  description = "Optional host header for ALB routing. Example: api.example.com."
  type        = string
  default     = null
}

variable "path_patterns" {
  description = "Optional ALB path patterns. Defaults to routing all paths."
  type        = list(string)
  default     = ["/*"]
}

variable "assign_public_ip" {
  description = "Whether ECS tasks should receive a public IP."
  type        = bool
  default     = false
}

variable "platform_version" {
  description = "ECS Fargate platform version."
  type        = string
  default     = "LATEST"
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention."
  type        = number
  default     = 30
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum healthy tasks during deployments."
  type        = number
  default     = 100
}

variable "deployment_maximum_percent" {
  description = "Maximum tasks during deployments."
  type        = number
  default     = 200
}

variable "task_role_policy_json" {
  description = "Optional inline IAM policy JSON for the application task role."
  type        = string
  default     = null
}

variable "ssm_paths" {
  description = "Backstage ssmPaths converted to a Terraform list."
  type        = list(string)
  default     = []
}

variable "secrets_manager_arns" {
  description = "Backstage secretsManagerArns converted to a Terraform list."
  type        = list(string)
  default     = []
}

variable "environment_variables" {
  description = "Plain-text container environment variables."
  type        = map(string)
  default     = {}
}

variable "enable_execute_command" {
  description = "Enable ECS Exec for the service."
  type        = bool
  default     = true
}

variable "enable_autoscaling" {
  description = "Create target tracking autoscaling policies for the ECS service."
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "Minimum desired count when autoscaling is enabled."
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum desired count when autoscaling is enabled."
  type        = number
  default     = 4
}

variable "autoscaling_cpu_target" {
  description = "Target average CPU utilization percentage."
  type        = number
  default     = 70
}

variable "autoscaling_memory_target" {
  description = "Target average memory utilization percentage."
  type        = number
  default     = 75
}

variable "target_group_deregistration_delay" {
  description = "ALB target group deregistration delay in seconds."
  type        = number
  default     = 30
}

variable "health_check_grace_period_seconds" {
  description = "Grace period before ECS starts considering ALB health checks."
  type        = number
  default     = 60
}

variable "tags" {
  description = "Additional tags applied to all created resources."
  type        = map(string)
  default     = {}
}
