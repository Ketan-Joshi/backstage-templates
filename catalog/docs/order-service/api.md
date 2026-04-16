# API Reference

The Order Service exposes a RESTful HTTP API. The full OpenAPI specification is available in the Backstage API catalog.

## Base URL

| Environment | URL |
|---|---|
| Production | `https://api.example.com/v1` |
| Staging | `https://api.staging.example.com/v1` |

## Authentication

All endpoints require a JWT bearer token:

```http
Authorization: Bearer <token>
```

Tokens are issued by the internal Auth Service. Contact the Platform Team for service-to-service credentials.

## Endpoints

### `POST /orders` — Create an order

```json
// Request
{
  "customerId": "550e8400-e29b-41d4-a716-446655440000",
  "items": [
    { "productId": "...", "quantity": 2, "unitPrice": 29.99 }
  ]
}

// Response 201
{
  "id": "...",
  "status": "pending",
  "totalAmount": 59.98,
  "currency": "USD",
  "createdAt": "2024-01-15T10:30:00Z"
}
```

### `GET /orders/{orderId}` — Get an order

```http
GET /orders/550e8400-e29b-41d4-a716-446655440001
```

### `PATCH /orders/{orderId}` — Update order status

```json
{ "status": "confirmed" }
```

### `DELETE /orders/{orderId}` — Cancel an order

Returns `204 No Content` on success.

## Error Codes

| Code | Meaning |
|---|---|
| `ORDER_NOT_FOUND` | The specified order does not exist |
| `INVALID_STATUS_TRANSITION` | The requested status change is not allowed |
| `PAYMENT_REQUIRED` | Order cannot be confirmed without payment |
| `INSUFFICIENT_STOCK` | One or more items are out of stock |

## Rate Limits

- **Authenticated requests**: 1000 req/min per service
- **Burst**: 200 req/s

!!! tip "SDK"
    An auto-generated Java SDK is available at `com.example:order-service-client`. See the [GitHub Packages registry](https://github.com/Ketan-Joshi/backstage-templates).
