# Order Service

The **Order Service** is the core microservice responsible for managing the full order lifecycle in the E-Commerce platform.

## Overview

| Property | Value |
|---|---|
| **Owner** | Backend Team |
| **Language** | Java 17 / Spring Boot 3 |
| **Runtime** | AWS ECS Fargate |
| **Database** | Amazon RDS PostgreSQL |
| **Messaging** | Apache Kafka |
| **Lifecycle** | Production |

## Responsibilities

- Accept and validate new orders from the Storefront
- Coordinate with the Payment Service to confirm payment
- Publish order lifecycle events to Kafka
- Expose the [Orders REST API](api.md) for downstream consumers

## Quick Links

- [GitHub Repository](https://github.com/Ketan-Joshi/backstage-templates)
- [Grafana Dashboard](https://grafana.example.com/d/order-service)
- [PagerDuty Service](https://example.pagerduty.com/services/PXXXXXX)
- [Sentry Project](https://sentry.io/organizations/Ketan-Joshi/projects/order-service)
- [ArgoCD Application](https://argocd.example.com/applications/order-service-production)

## Getting Started

```bash
# Clone the repository
git clone https://github.com/Ketan-Joshi/backstage-templates.git
cd backstage-templates

# Run locally with Docker Compose
docker compose up -d

# Run tests
./mvnw test

# Build and push Docker image
./mvnw spring-boot:build-image
```

## Dependencies

```
order-service
├── orders-db (RDS PostgreSQL)
├── orders-kafka-topic (Kafka)
├── payment-service (via Payment API)
└── notification-service (via Notification API)
```

!!! info "On-call"
    The Backend Team is on-call for this service. See the [Incident Response runbook](runbooks/incident-response.md) for escalation procedures.
