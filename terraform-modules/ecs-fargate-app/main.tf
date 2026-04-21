data "aws_region" "current" {}

data "aws_ssm_parameter" "container_secrets" {
  for_each = toset(var.ssm_paths)
  name     = each.value
}

locals {
  name_prefix           = "${var.service_name}-${var.environment}"
  use_existing_listener = var.alb_listener_arn != null
  create_listener       = var.alb_listener_arn == null

  default_tags = {
    Name        = local.name_prefix
    Service     = var.service_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }

  enriched_tags = merge(
    local.default_tags,
    var.owner != null ? { Owner = var.owner } : {},
    var.description != null ? { Description = var.description } : {},
    var.tags,
  )

  ssm_secrets = [
    for path, parameter in data.aws_ssm_parameter.container_secrets : {
      name      = upper(regexreplace(basename(path), "[^A-Za-z0-9_]", "_"))
      valueFrom = parameter.arn
    }
  ]

  secrets_manager_secrets = [
    for arn in var.secrets_manager_arns : {
      name      = upper(regexreplace(element(reverse(split("/", arn)), 0), "[^A-Za-z0-9_]", "_"))
      valueFrom = arn
    }
  ]

  container_secrets = concat(local.ssm_secrets, local.secrets_manager_secrets)

  execution_secret_arns = concat(
    [for parameter in data.aws_ssm_parameter.container_secrets : parameter.arn],
    var.secrets_manager_arns,
  )
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/ecs/${local.name_prefix}"
  retention_in_days = var.log_retention_in_days
  tags              = local.enriched_tags
}

resource "aws_iam_role" "execution" {
  name = "${local.name_prefix}-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.enriched_tags
}

resource "aws_iam_role_policy_attachment" "execution_managed" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "execution_secrets" {
  count = length(local.execution_secret_arns) > 0 ? 1 : 0
  name  = "${local.name_prefix}-execution-secrets"
  role  = aws_iam_role.execution.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameters",
          "ssm:GetParameter",
          "secretsmanager:GetSecretValue",
        ]
        Resource = local.execution_secret_arns
      },
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role" "task" {
  name = "${local.name_prefix}-task"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.enriched_tags
}

resource "aws_iam_role_policy" "task_inline" {
  count  = var.task_role_policy_json != null ? 1 : 0
  name   = "${local.name_prefix}-task-inline"
  role   = aws_iam_role.task.id
  policy = var.task_role_policy_json
}

resource "aws_lb_target_group" "this" {
  name                 = substr(replace(local.name_prefix, "_", "-"), 0, 32)
  port                 = var.port
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.vpc_id
  deregistration_delay = var.target_group_deregistration_delay

  health_check {
    enabled             = true
    path                = var.health_check_path
    port                = "traffic-port"
    protocol            = "HTTP"
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 3
    interval            = 30
    timeout             = 5
  }

  tags = local.enriched_tags
}

resource "aws_lb_listener" "this" {
  count             = local.create_listener ? 1 : 0
  load_balancer_arn = var.load_balancer_arn
  port              = var.listener_port
  protocol          = upper(var.listener_protocol)
  ssl_policy        = upper(var.listener_protocol) == "HTTPS" ? var.ssl_policy : null
  certificate_arn   = upper(var.listener_protocol) == "HTTPS" ? var.certificate_arn : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = local.enriched_tags
}

resource "aws_lb_listener_rule" "this" {
  count        = local.use_existing_listener ? 1 : 0
  listener_arn = var.alb_listener_arn
  priority     = var.listener_rule_priority

  dynamic "condition" {
    for_each = var.host_header != null ? [var.host_header] : []
    content {
      host_header {
        values = [condition.value]
      }
    }
  }

  dynamic "condition" {
    for_each = length(var.path_patterns) > 0 ? [var.path_patterns] : []
    content {
      path_pattern {
        values = condition.value
      }
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  lifecycle {
    precondition {
      condition     = var.listener_rule_priority != null
      error_message = "listener_rule_priority is required when alb_listener_arn is provided."
    }
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = local.name_prefix
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.execution.arn
  task_role_arn            = aws_iam_role.task.arn

  container_definitions = jsonencode([
    {
      name      = var.service_name
      image     = var.container_image
      essential = true

      portMappings = [
        {
          containerPort = var.port
          hostPort      = var.port
          protocol      = "tcp"
        }
      ]

      environment = [
        for key, value in var.environment_variables : {
          name  = key
          value = value
        }
      ]

      secrets = local.container_secrets

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = var.service_name
        }
      }
    }
  ])

  tags = local.enriched_tags
}

resource "aws_ecs_service" "this" {
  name                               = local.name_prefix
  cluster                            = var.cluster
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"
  platform_version                   = var.platform_version
  enable_execute_command             = var.enable_execute_command
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent
  deployment_maximum_percent         = var.deployment_maximum_percent

  network_configuration {
    assign_public_ip = var.assign_public_ip
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = var.service_name
    container_port   = var.port
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
    ]

    precondition {
      condition = (
        local.use_existing_listener ||
        var.load_balancer_arn != null
      )
      error_message = "Set alb_listener_arn to reuse an existing listener, or set load_balancer_arn so the module can create a new listener."
    }

    precondition {
      condition = (
        !local.create_listener ||
        contains(["HTTP", "HTTPS"], upper(var.listener_protocol))
      )
      error_message = "listener_protocol must be HTTP or HTTPS when creating a listener."
    }

    precondition {
      condition = (
        !local.create_listener ||
        upper(var.listener_protocol) != "HTTPS" ||
        var.certificate_arn != null
      )
      error_message = "certificate_arn is required when creating an HTTPS listener."
    }
  }

  depends_on = [
    aws_lb_listener.this,
    aws_lb_listener_rule.this,
  ]

  tags = local.enriched_tags
}

resource "aws_appautoscaling_target" "this" {
  count              = var.enable_autoscaling ? 1 : 0
  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = var.autoscaling_min_capacity
  resource_id        = "service/${element(reverse(split("/", var.cluster)), 0)}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu" {
  count              = var.enable_autoscaling ? 1 : 0
  name               = "${local.name_prefix}-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this[0].resource_id
  scalable_dimension = aws_appautoscaling_target.this[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = var.autoscaling_cpu_target
  }
}

resource "aws_appautoscaling_policy" "memory" {
  count              = var.enable_autoscaling ? 1 : 0
  name               = "${local.name_prefix}-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this[0].resource_id
  scalable_dimension = aws_appautoscaling_target.this[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.this[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = var.autoscaling_memory_target
  }
}
