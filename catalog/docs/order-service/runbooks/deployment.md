# Deployment Runbook

## Normal Deployment

Deployments are fully automated via GitHub Actions + ArgoCD. Merging to `main` triggers a deployment to staging; production requires a manual promotion.

### Steps

1. Merge PR to `main`
2. GitHub Actions builds and pushes Docker image to ECR
3. ArgoCD detects the new image tag and syncs to staging automatically
4. Run smoke tests: `make smoke-test ENV=staging`
5. Promote to production in ArgoCD UI or via CLI:

```bash
argocd app sync order-service-production --revision <image-tag>
```

## Rollback

```bash
# Roll back to the previous revision
argocd app rollback order-service-production

# Or roll back to a specific revision
argocd app rollback order-service-production --revision <previous-tag>
```

## Environment Variables

| Variable | Description | Required |
|---|---|---|
| `DATABASE_URL` | PostgreSQL connection string | Yes |
| `KAFKA_BOOTSTRAP_SERVERS` | Kafka broker addresses | Yes |
| `PAYMENT_SERVICE_URL` | Payment Service base URL | Yes |
| `NOTIFICATION_SERVICE_URL` | Notification Service base URL | Yes |
| `JWT_SECRET` | JWT signing secret (from Secrets Manager) | Yes |
| `LOG_LEVEL` | Logging level (default: INFO) | No |

!!! danger "Secrets"
    Never commit secrets to Git. All secrets are stored in AWS Secrets Manager and injected at runtime via ECS task definition secrets.
