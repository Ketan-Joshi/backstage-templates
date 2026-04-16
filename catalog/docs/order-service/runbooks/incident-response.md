# Incident Response Runbook

## Severity Levels

| Severity | Definition | Response Time |
|---|---|---|
| P1 | Orders cannot be placed (revenue impact) | 15 minutes |
| P2 | Degraded performance, partial failures | 1 hour |
| P3 | Non-critical issues, monitoring alerts | Next business day |

## Common Issues

### High Error Rate (5xx)

1. Check [Grafana dashboard](https://grafana.example.com/d/order-service) for error rate and latency
2. Check [Sentry](https://sentry.io/organizations/Ketan-Joshi/projects/order-service) for exception details
3. Check ECS task logs:
   ```bash
   aws logs tail /ecs/order-service --follow --region us-east-1
   ```
4. If database-related: check RDS CloudWatch metrics for CPU/connections
5. If Kafka-related: check consumer lag in [Kafka UI](https://kafka-ui.example.com)

1. Check ECS service health in AWS Console
2. Verify all tasks are running: `aws ecs describe-services --cluster prod --services order-service`
3. Check ALB target group health
4. If tasks are crashing: check task stopped reason in ECS console

### Database Connection Exhaustion

1. Check current connections: `SELECT count(*) FROM pg_stat_activity;`
2. Kill idle connections if needed
3. Restart PgBouncer if connection pooler is stuck
4. Scale down ECS tasks temporarily if needed

## Escalation

1. **On-call engineer** — PagerDuty auto-pages the Backend Team on-call
2. **Backend Team lead** — Escalate after 30 minutes without resolution
3. **Platform Team** — Escalate for infrastructure issues (ECS, RDS, Kafka)
4. **CTO** — P1 incidents lasting more than 1 hour

## Post-Incident

File a post-mortem within 48 hours using the [post-mortem template](https://wiki.example.com/post-mortem-template).
