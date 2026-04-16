# Architecture

## System Context

The Order Service sits at the heart of the Order Management System. It receives order requests from the Storefront, coordinates payment via the Payment Service, and publishes events consumed by downstream systems.

```
┌─────────────────┐        REST         ┌──────────────────┐
│  Storefront Web │ ──────────────────► │  Order Service   │
└─────────────────┘                     └────────┬─────────┘
                                                 │
                          ┌──────────────────────┼──────────────────────┐
                          │                      │                      │
                          ▼                      ▼                      ▼
                  ┌───────────────┐   ┌──────────────────┐   ┌─────────────────┐
                  │  Payment API  │   │  RDS PostgreSQL  │   │  Kafka Topic    │
                  └───────────────┘   └──────────────────┘   │ orders.events   │
                                                              └────────┬────────┘
                                                                       │
                                              ┌────────────────────────┤
                                              │                        │
                                              ▼                        ▼
                                   ┌──────────────────┐   ┌───────────────────────┐
                                   │ Notification Svc │   │ Order Events Pipeline │
                                   └──────────────────┘   └───────────────────────┘
```

## Technology Stack

| Layer | Technology |
|---|---|
| Language | Java 17 |
| Framework | Spring Boot 3.2 |
| Database | PostgreSQL 15 (RDS) |
| Messaging | Apache Kafka 3.5 |
| Container | Docker / ECS Fargate |
| CI/CD | GitHub Actions + ArgoCD |
| Observability | Datadog APM + Grafana |

## Data Model

### Orders Table

```sql
CREATE TABLE orders (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    customer_id UUID NOT NULL,
    status      VARCHAR(20) NOT NULL DEFAULT 'pending',
    total_amount DECIMAL(10,2) NOT NULL,
    currency    CHAR(3) NOT NULL DEFAULT 'USD',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### Order Items Table

```sql
CREATE TABLE order_items (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id    UUID NOT NULL REFERENCES orders(id),
    product_id  UUID NOT NULL,
    quantity    INT NOT NULL CHECK (quantity > 0),
    unit_price  DECIMAL(10,2) NOT NULL,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

## Scaling

The service is horizontally scalable. ECS auto-scaling is configured to scale between 2 and 20 tasks based on CPU utilisation (target: 60%) and request count per target.

!!! warning "Database connections"
    Use PgBouncer connection pooling. Do not increase `desiredCount` beyond 20 without first increasing the RDS `max_connections` parameter.
