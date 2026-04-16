# ADR-001: Use PostgreSQL as the Primary Database

**Status**: Accepted  
**Date**: 2023-06-01  
**Deciders**: Backend Team, Platform Team

## Context

The Order Service needs a reliable, ACID-compliant relational database to store order records. We evaluated several options.

## Decision

We will use **Amazon RDS PostgreSQL** as the primary database for the Order Service.

## Rationale

| Criterion | PostgreSQL | MySQL | DynamoDB |
|---|---|---|---|
| ACID compliance | ✅ Full | ✅ Full | ⚠️ Limited |
| Complex queries | ✅ Excellent | ✅ Good | ❌ Limited |
| JSON support | ✅ JSONB | ⚠️ Basic | ✅ Native |
| Managed service | ✅ RDS | ✅ RDS | ✅ Native |
| Team familiarity | ✅ High | ✅ High | ⚠️ Low |

## Consequences

- **Positive**: Strong consistency, rich query capabilities, familiar tooling
- **Negative**: Requires connection pooling (PgBouncer) at scale; vertical scaling has limits
- **Mitigation**: Use read replicas for reporting queries; implement PgBouncer for connection pooling
