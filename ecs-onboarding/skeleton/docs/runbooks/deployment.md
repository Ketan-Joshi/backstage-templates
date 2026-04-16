# Deployment Runbook

## Overview

`${{ values.serviceName }}` is deployed to AWS ECS Fargate via the GoCD pipeline.

## Deployment Process

1. Merge PR to `main`
2. GoCD pipeline builds and pushes Docker image to ECR
3. ECS service is updated with the new image tag

## Rollback

To roll back to a previous version:

```bash
# List recent task definitions
aws ecs list-task-definitions --family-prefix ${{ values.serviceName }} --sort DESC

# Update service to use a previous task definition
aws ecs update-service \
  --cluster backstage-poc-cluster \
  --service ${{ values.serviceName }} \
  --task-definition ${{ values.serviceName }}:<previous-revision>
```

## Environment Variables

| Variable | Description | Required |
|---|---|---|
| `PORT` | Container port (default: ${{ values.containerPort }}) | No |
| `NODE_ENV` | Node environment | Yes |
| `LOG_LEVEL` | Logging level (default: info) | No |

!!! danger "Secrets"
    Store all secrets in AWS Secrets Manager. Never commit secrets to Git.
