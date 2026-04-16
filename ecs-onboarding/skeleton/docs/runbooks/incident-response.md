# Incident Response Runbook

## On-Call

This service is owned by **${{ values.owner }}**. Check PagerDuty for the current on-call engineer.

## Common Issues

### Service Unavailable

1. Check ECS service health:
   ```bash
   aws ecs describe-services --cluster main-cluster --services ${{ values.serviceName }}
   ```
2. Check task logs:
   ```bash
   aws logs tail /ecs/${{ values.serviceName }} --follow
   ```
3. Check ALB target group health in AWS Console

### High Error Rate

1. Check application logs for exceptions
2. Check downstream service health (dependencies)
3. Consider rolling back if a recent deployment caused the issue

## Escalation

1. On-call engineer (PagerDuty auto-page)
2. Team lead for ${{ values.owner }}
3. Platform Team for infrastructure issues
