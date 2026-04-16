# ${{ values.serviceName }}

${{ values.description }}

## Overview

| Property | Value |
|---|---|
| **Owner** | ${{ values.owner }} |
| **System** | ${{ values.system }} |
| **Environment** | ${{ values.environment }} |
| **Container port** | ${{ values.containerPort }} |
| **Health check** | `${{ values.healthCheckPath }}` |

## Getting Started

```bash
# Clone the repository
git clone https://github.com/${{ values.repoOrg }}/${{ values.repoName }}.git
cd ${{ values.repoName }}

# Build the Docker image
docker build -t ${{ values.serviceName }} .

# Run locally
docker run -p ${{ values.containerPort }}:${{ values.containerPort }} ${{ values.serviceName }}
```

## Deployment

This service is deployed to AWS ECS Fargate via the GoCD pipeline.

- **ECR Repository**: `Ketan-Joshi/${{ values.serviceName }}`
- **ECS Cluster**: `backstage-poc-cluster`
- **ECS Service**: `${{ values.serviceName }}`

## Documentation

Full documentation is available in the [Backstage catalog](https://backstage.example.com/catalog/default/component/${{ values.serviceName }}).

## Links

- [GitHub Repository](https://github.com/${{ values.repoOrg }}/${{ values.repoName }})
- [ECS Service](https://console.aws.amazon.com/ecs/home#/clusters/main-cluster/services/${{ values.serviceName }})
{% if values.enableDatadog %}- [Datadog APM](https://app.datadoghq.com/apm/services/${{ values.serviceName }}){% endif %}
{% if values.enableSentry %}- [Sentry](https://sentry.io/organizations/${{ values.repoOrg }}/projects/${{ values.serviceName }}){% endif %}
