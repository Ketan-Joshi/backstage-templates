# ADR-002: Use Kafka for Order Event Publishing

**Status**: Accepted  
**Date**: 2023-07-15  
**Deciders**: Backend Team, Data Team

## Context

The Order Service needs to notify downstream systems (Notification Service, Data Pipeline) when order state changes. We need a reliable, scalable event bus.

## Decision

We will use **Apache Kafka** (Amazon MSK) for publishing order lifecycle events.

## Rationale

- **Durability**: Events are persisted and replayable — critical for the Data Pipeline
- **Fan-out**: Multiple consumers can independently read the same events
- **Throughput**: Handles millions of events/day without bottlenecks
- **Schema evolution**: Avro schemas with Schema Registry allow backward-compatible changes

## Consequences

- **Positive**: Decoupled architecture, event replay capability, high throughput
- **Negative**: Operational complexity; consumers must handle at-least-once delivery
- **Mitigation**: Use idempotency keys in all consumers; monitor consumer lag via Datadog
