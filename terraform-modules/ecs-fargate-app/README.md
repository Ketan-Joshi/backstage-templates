# ECS Fargate App Module

This module creates the AWS infrastructure needed to deploy an application to ECS Fargate behind an Application Load Balancer. It can either attach to an existing listener or create a new listener for you.

It is designed to line up with the inputs already defined in [ecs-onboarding/template.yaml](../../ecs-onboarding/template.yaml), while adding the AWS-specific values that Terraform needs but the Backstage form does not currently collect.

## What it creates

- CloudWatch log group for container logs
- ECS task execution role
- ECS task role
- ECS task definition
- ECS service
- ALB target group
- ALB listener rule or ALB listener
- Optional ECS service autoscaling policies

## Backstage input mapping

| Backstage field | Terraform variable | Notes |
|---|---|---|
| `serviceName` | `service_name` | Required |
| `description` | `description` | Optional metadata tag |
| `owner` | `owner` | Optional metadata tag |
| `environment` | `environment` | Required |
| `cpu` | `cpu` | Keep the same string values from Backstage |
| `memory` | `memory` | Keep the same string values from Backstage |
| `port` | `port` | Required |
| `healthCheckPath` | `health_check_path` | Defaults to `/health` |
| `desiredCount` | `desired_count` | Defaults to `1` |
| `cluster` | `cluster` | Accepts ECS cluster name or ARN |
| `ssmPaths` | `ssm_paths` | Convert the textarea into a list of strings |
| `secretsManagerArns` | `secrets_manager_arns` | Convert the textarea into a list of strings |

## Additional inputs needed for Terraform

The current Backstage template is oriented around handing deployment off to Harness, so Terraform still needs a few infrastructure values that are not present in the form today:

- `container_image`
- `vpc_id`
- `subnet_ids`
- `security_group_ids`

For ALB routing, choose one of these two patterns:

1. Reuse an existing listener
- `alb_listener_arn`
- `listener_rule_priority`

2. Create a new listener
- `load_balancer_arn`
- `listener_port`
- `listener_protocol`
- `certificate_arn` for HTTPS only

## Direct module usage

You can call the module directly from any root Terraform configuration.

```hcl
module "payments_service" {
  source = "./terraform-modules/ecs-fargate-app"

  service_name = "payment-service"
  description  = "Processes card payments"
  owner        = "group:default/backend-team"
  environment  = "dev"

  cpu           = "512"
  memory        = "1024"
  port          = 8080
  desired_count = 2
  cluster       = "shared-dev-cluster"

  container_image        = "123456789012.dkr.ecr.us-east-1.amazonaws.com/payment-service:1.2.3"
  vpc_id                 = "vpc-0123456789abcdef0"
  subnet_ids             = ["subnet-aaa", "subnet-bbb", "subnet-ccc"]
  security_group_ids     = ["sg-0123456789abcdef0"]
  alb_listener_arn       = "arn:aws:elasticloadbalancing:us-east-1:123456789012:listener/app/shared/50dc6c495c0c9188/0f4c2b6f4a8b7c9d"
  listener_rule_priority = 120

  host_header   = "payments.dev.example.com"
  path_patterns = ["/", "/health", "/api/*"]

  ssm_paths = [
    "/payment-service/dev/DB_HOST",
    "/payment-service/dev/DB_PASSWORD",
  ]

  secrets_manager_arns = [
    "arn:aws:secretsmanager:us-east-1:123456789012:secret:payment-service/api-key-AbCdEf",
  ]

  environment_variables = {
    LOG_LEVEL = "info"
    NODE_ENV  = "development"
  }

  enable_autoscaling       = true
  autoscaling_min_capacity = 2
  autoscaling_max_capacity = 6
}
```

## Listener behavior

The module supports two ALB modes.

### Option 1: Use an existing listener

Pass:

- `alb_listener_arn`
- `listener_rule_priority`

Optional routing inputs:

- `host_header`
- `path_patterns`

In this mode, the module creates an `aws_lb_listener_rule` and forwards traffic from the existing listener to the new target group.

### Option 2: Create a new listener

Pass:

- `load_balancer_arn`
- `listener_port`
- `listener_protocol`

Optional:

- `certificate_arn` when `listener_protocol = "HTTPS"`
- `ssl_policy` for HTTPS listeners

In this mode:

- `alb_listener_arn` should be omitted
- `listener_rule_priority` is not required
- the new listener forwards directly to this service target group

## Included caller configuration

A ready-to-run caller configuration is included here:

- [example-usage/main.tf](/Users/yashkhandelwal/Projects/Personal/backstage-templates/terraform-modules/ecs-fargate-app/example-usage/main.tf:1)
- [example-usage/variables.tf](/Users/yashkhandelwal/Projects/Personal/backstage-templates/terraform-modules/ecs-fargate-app/example-usage/variables.tf:1)
- [example-usage/versions.tf](/Users/yashkhandelwal/Projects/Personal/backstage-templates/terraform-modules/ecs-fargate-app/example-usage/versions.tf:1)

This caller just forwards variables into the module, so the user only needs to run Terraform commands in that folder and pass values with `-var`.

## How to use the included caller

### 1. Move into the caller folder

```bash
cd terraform-modules/ecs-fargate-app/example-usage
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Run plan and pass variables inline

Example:

```bash
terraform plan \
  -out=tfplan \
  -var="aws_region=us-east-1" \
  -var="service_name=payment-service" \
  -var="description=Processes card payments" \
  -var="owner=group:default/backend-team" \
  -var="environment=dev" \
  -var="cpu=512" \
  -var="memory=1024" \
  -var="port=8080" \
  -var="desired_count=2" \
  -var="cluster=shared-dev-cluster" \
  -var="container_image=123456789012.dkr.ecr.us-east-1.amazonaws.com/payment-service:1.2.3" \
  -var="vpc_id=vpc-0123456789abcdef0" \
  -var='subnet_ids=["subnet-aaa","subnet-bbb","subnet-ccc"]' \
  -var='security_group_ids=["sg-0123456789abcdef0"]' \
  -var="alb_listener_arn=arn:aws:elasticloadbalancing:us-east-1:123456789012:listener/app/shared/50dc6c495c0c9188/0f4c2b6f4a8b7c9d" \
  -var="listener_rule_priority=120" \
  -var="host_header=payments.dev.example.com" \
  -var='path_patterns=["/","/health","/api/*"]' \
  -var='ssm_paths=["/payment-service/dev/DB_HOST","/payment-service/dev/DB_PASSWORD"]' \
  -var='secrets_manager_arns=["arn:aws:secretsmanager:us-east-1:123456789012:secret:payment-service/api-key-AbCdEf"]' \
  -var='environment_variables={LOG_LEVEL="info",NODE_ENV="development"}' \
  -var="enable_autoscaling=true" \
  -var="autoscaling_min_capacity=2" \
  -var="autoscaling_max_capacity=6"
```

### 4. Apply the saved plan

```bash
terraform apply tfplan
```

### 5. Alternative plan example when creating a new listener

```bash
terraform plan \
  -out=tfplan \
  -var="aws_region=us-east-1" \
  -var="service_name=payment-service" \
  -var="environment=dev" \
  -var="cpu=512" \
  -var="memory=1024" \
  -var="port=8080" \
  -var="cluster=shared-dev-cluster" \
  -var="container_image=123456789012.dkr.ecr.us-east-1.amazonaws.com/payment-service:1.2.3" \
  -var="vpc_id=vpc-0123456789abcdef0" \
  -var='subnet_ids=["subnet-aaa","subnet-bbb"]' \
  -var='security_group_ids=["sg-0123456789abcdef0"]' \
  -var="load_balancer_arn=arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/shared/50dc6c495c0c9188" \
  -var="listener_port=80" \
  -var="listener_protocol=HTTP"
```

## Common override pattern

If you want to keep the command shorter, set only the required values inline and let optional values use their defaults:

```bash
terraform plan \
  -out=tfplan \
  -var="aws_region=us-east-1" \
  -var="service_name=payment-service" \
  -var="environment=dev" \
  -var="cpu=512" \
  -var="memory=1024" \
  -var="port=8080" \
  -var="cluster=shared-dev-cluster" \
  -var="container_image=123456789012.dkr.ecr.us-east-1.amazonaws.com/payment-service:1.2.3" \
  -var="vpc_id=vpc-0123456789abcdef0" \
  -var='subnet_ids=["subnet-aaa","subnet-bbb"]' \
  -var='security_group_ids=["sg-0123456789abcdef0"]' \
  -var="alb_listener_arn=arn:aws:elasticloadbalancing:us-east-1:123456789012:listener/app/shared/50dc6c495c0c9188/0f4c2b6f4a8b7c9d" \
  -var="listener_rule_priority=120"
```

Then:

```bash
terraform apply tfplan
```

## Variables you will usually pass

Required in most real deployments:

- `aws_region`
- `service_name`
- `environment`
- `cpu`
- `memory`
- `port`
- `cluster`
- `container_image`
- `vpc_id`
- `subnet_ids`
- `security_group_ids`
- either `alb_listener_arn` and `listener_rule_priority`
- or `load_balancer_arn`, `listener_port`, and `listener_protocol`

Common optional overrides:

- `description`
- `owner`
- `health_check_path`
- `desired_count`
- `host_header`
- `path_patterns`
- `ssm_paths`
- `secrets_manager_arns`
- `environment_variables`
- `enable_autoscaling`

## Notes for Backstage integration

- `repoUrl`, `branch`, and `dockerfilePath` from the existing Backstage template are CI/CD concerns, so this module does not use them directly.
- `ssm_paths` entries are resolved to parameter ARNs and injected into the container as secrets using the final path segment as the environment variable name.
- `secrets_manager_arns` are injected as container secrets using the secret name suffix as the environment variable name.
- The ECS service ignores changes to `task_definition` and `desired_count` so external deploy systems can update image revisions or autoscaling without fighting Terraform state on every rollout.
- The included caller configuration is a convenience wrapper. You can keep using it as-is, or replace it with your own environment-specific root module later.
