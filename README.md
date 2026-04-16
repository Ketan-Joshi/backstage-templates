# Backstage POC — Feature Showcase

This repository is a comprehensive Backstage proof-of-concept that demonstrates every major Backstage feature in a realistic e-commerce platform context.

---

## Features Showcased

| Feature | Where |
|---|---|
| **Software Catalog** — all entity kinds | `catalog/` |
| **Software Templates (Scaffolder)** | `ecs-onboarding/`, `nodejs-library/`, `documentation-site/`, `data-pipeline/` |
| **TechDocs** | `catalog/docs/`, every skeleton has `mkdocs.yml` |
| **API Catalog** — OpenAPI, AsyncAPI, GraphQL, gRPC | `catalog/api-specs/` |
| **Org Model** — Groups, Users | `catalog/org/` |
| **Domains & Systems** | `catalog/domains-and-systems.yaml` |
| **Resources** | `catalog/resources.yaml` |
| **Relations** | `dependsOn`, `providesApis`, `consumesApis`, `partOf`, `memberOf` |
| **Annotations** | GitHub, K8s, PagerDuty, Datadog, Sentry, ArgoCD, SonarQube, Lighthouse |
| **Tech Insights / Scorecards** | `backstage-config/tech-insights-scorecards.yaml` |
| **Kubernetes plugin** | `backstage.io/kubernetes-*` annotations on components |
| **app-config.yaml** | `backstage-config/app-config.yaml` |

---

## Repository Structure

```
.
├── catalog/
│   ├── all.yaml                    ← Root Location — register this one URL in Backstage
│   ├── org/
│   │   ├── groups.yaml             ← Group entities (platform, backend, frontend, data, engineering)
│   │   └── users.yaml              ← User entities (alice, bob, carol, dave, eve, frank, grace)
│   ├── domains-and-systems.yaml    ← Domain + System entities
│   ├── components.yaml             ← Component entities (service, library, website, documentation)
│   ├── apis.yaml                   ← API entities (OpenAPI, AsyncAPI, GraphQL, gRPC)
│   ├── resources.yaml              ← Resource entities (RDS, S3, Kafka, CloudFront, Redshift)
│   ├── api-specs/
│   │   ├── orders-openapi.yaml     ← Full OpenAPI 3.0 spec
│   │   ├── payment-openapi.yaml    ← Full OpenAPI 3.0 spec
│   │   ├── notification-openapi.yaml
│   │   ├── product-catalogue.graphql ← GraphQL schema
│   │   ├── orders-asyncapi.yaml    ← AsyncAPI 2.6 spec (Kafka)
│   │   └── inventory.proto         ← Protobuf / gRPC spec
│   └── docs/
│       └── order-service/          ← Full TechDocs site (index, architecture, API, runbooks, ADRs)
│
├── ecs-onboarding/                 ← Template: ECS Fargate service (enhanced)
│   ├── template.yaml
│   └── skeleton/                   ← Rendered into new repos
│       ├── catalog-info.yaml
│       ├── Dockerfile
│       ├── README.md
│       ├── mkdocs.yml
│       └── docs/
│
├── nodejs-library/                 ← Template: TypeScript npm library
│   ├── template.yaml
│   └── skeleton/
│
├── documentation-site/             ← Template: TechDocs documentation site
│   ├── template.yaml
│   └── skeleton/
│
├── data-pipeline/                  ← Template: Python data pipeline
│   ├── template.yaml
│   └── skeleton/
│
└── backstage-config/
    ├── app-config.yaml             ← Backstage config snippet (all plugins wired up)
    └── tech-insights-scorecards.yaml ← Scorecard definitions
```

---

## Catalog Entity Kinds

| Kind | Count | Examples |
|---|---|---|
| `Domain` | 2 | ecommerce, data-platform |
| `System` | 4 | order-management, storefront, data-ingestion, platform-tooling |
| `Component` | 7 | order-service, payment-service, storefront-web, design-system, … |
| `API` | 6 | orders-api (OpenAPI), product-catalogue-api (GraphQL), orders-events (AsyncAPI), inventory (gRPC) |
| `Resource` | 7 | orders-db, payments-db, orders-kafka-topic, static-assets-bucket, redshift-cluster, … |
| `Group` | 5 | platform-team, backend-team, frontend-team, data-team, engineering |
| `User` | 7 | alice, bob, carol, dave, eve, frank, grace |
| `Template` | 4 | ecs-service-onboarding, nodejs-library, documentation-site, data-pipeline |
| `Location` | 1 | backstage-poc-root |

---

## Software Templates

### 1. ECS Service Onboarding (`ecs-onboarding/`)
Creates a GitHub repo, ECR repository, ECS Fargate service, GoCD pipeline, and PagerDuty service in one click. Showcases:
- Multi-page wizard with `OwnerPicker`, `EntityPicker`, conditional fields
- `fetch:template`, `publish:github`, `aws:ecr:create`, `aws:ecs:create-service`, `gocd:create-pipeline`, `pagerduty:service:create`, `catalog:register` actions
- Conditional steps (`if:` on PagerDuty)
- Rich `output.links` and `output.text`
- Skeleton with Jinja2 templating, conditional blocks, loops

### 2. Node.js Library (`nodejs-library/`)
Scaffolds a TypeScript npm library with testing, linting, and semantic-release. Showcases:
- `type: library` component
- npm scope parameter
- `sonarqube.org/project-key` annotation

### 3. Documentation Site (`documentation-site/`)
Creates a MkDocs TechDocs site. Showcases:
- `type: documentation` component
- `backstage.io/techdocs-ref: dir:.` annotation
- Full `mkdocs.yml` with `techdocs-core` plugin

### 4. Data Pipeline (`data-pipeline/`)
Scaffolds a Python data pipeline (Kafka Streams, batch ETL, or Spark). Showcases:
- Data team ownership
- Airflow DAG link annotation
- Conditional schedule field

---

## Annotations Reference

Every component in this POC uses a rich set of annotations to demonstrate plugin integrations:

```yaml
annotations:
  # TechDocs
  backstage.io/techdocs-ref: dir:.

  # Source control
  github.com/project-slug: org/repo

  # Kubernetes plugin
  backstage.io/kubernetes-id: my-service
  backstage.io/kubernetes-namespace: production
  backstage.io/kubernetes-label-selector: app=my-service

  # PagerDuty
  pagerduty.com/service-id: PXXXXXX

  # Datadog
  datadoghq.com/dashboard-url: https://app.datadoghq.com/dashboard/...
  datadoghq.com/slo-url: https://app.datadoghq.com/slo/...

  # Sentry
  sentry.io/project-slug: my-service

  # ArgoCD
  argocd/app-name: my-service-production

  # SonarQube
  sonarqube.org/project-key: org_my-service

  # Lighthouse (for websites)
  lighthouse.com/website-url: https://www.example.com

  # Jira
  jira/project-key: ORD

  # AWS
  aws.amazon.com/arn: arn:aws:...
```

---

## Registering in Backstage

Add this single URL to your `app-config.yaml`:

```yaml
catalog:
  locations:
    - type: url
      target: https://github.com/YOUR-ORG/YOUR-REPO/blob/main/catalog/all.yaml
      rules:
        - allow: [Component, API, Resource, System, Domain, Group, User, Location, Template]
```

See `backstage-config/app-config.yaml` for the full configuration including all plugin settings.

---

## Required Backstage Plugins

| Plugin | npm package |
|---|---|
| Catalog | `@backstage/plugin-catalog` (built-in) |
| Scaffolder | `@backstage/plugin-scaffolder` (built-in) |
| TechDocs | `@backstage/plugin-techdocs` (built-in) |
| API Docs | `@backstage/plugin-api-docs` (built-in) |
| Kubernetes | `@backstage/plugin-kubernetes` |
| GitHub Actions | `@backstage-community/plugin-github-actions` |
| PagerDuty | `@pagerduty/backstage-plugin` |
| Datadog | `@roadiehq/backstage-plugin-datadog` |
| Sentry | `@backstage/plugin-sentry` |
| ArgoCD | `@roadiehq/backstage-plugin-argo-cd` |
| SonarQube | `@backstage/plugin-sonarqube` |
| Lighthouse | `@backstage/plugin-lighthouse` |
| Tech Insights | `@backstage/plugin-tech-insights` |
| Org Graph | `@backstage/plugin-org` (built-in) |
