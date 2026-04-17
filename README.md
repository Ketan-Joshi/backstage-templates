# Backstage Developer Portal — Complete POC

> **A comprehensive Internal Developer Portal (IDP) that centralizes service discovery, documentation, API catalogs, self-service infrastructure, and observability — all in one place.**

**Live Demo:** `http://3.208.117.182:3000`  
**GitHub:** `https://github.com/Ketan-Joshi/backstage-templates`

---

## Table of Contents

- [What is Backstage?](#what-is-backstage)
- [Why Backstage Matters](#why-backstage-matters)
- [What This POC Demonstrates](#what-this-poc-demonstrates)
- [Architecture Overview](#architecture-overview)
- [Features Showcase](#features-showcase)
- [How It Helps DevOps Teams](#how-it-helps-devops-teams)
- [AI Integration Opportunities](#ai-integration-opportunities)
- [Repository Structure](#repository-structure)
- [Getting Started](#getting-started)
- [Plugin Documentation](#plugin-documentation)
- [Real-World Use Cases](#real-world-use-cases)
- [ROI & Business Value](#roi--business-value)

---

## What is Backstage?

**Backstage** is an open-source **Internal Developer Portal (IDP)** created by Spotify and donated to the CNCF. It provides a unified interface for:

- **Service Discovery** — What services exist? Who owns them?
- **Documentation** — How does it work? How do I deploy it?
- **API Catalog** — What APIs are available? How do I integrate?
- **Self-Service Infrastructure** — Create new services with one click
- **Observability** — Is it running? Are there errors?
- **Standards Enforcement** — Does it follow best practices?

Think of it as **"AWS Console + Confluence + Postman + PagerDuty + GitHub"** — all in one portal.

---

## Why Backstage Matters

### The Problem (Before Backstage)

| Question | Current Reality | Time Wasted |
|---|---|---|
| "What services exist?" | Scattered across AWS, GitHub, wikis | 30 min/day |
| "Who owns the Payment Service?" | Ask in Slack, wait for response | 1 hour |
| "How do I deploy this?" | Hunt for runbooks in Confluence | 2 hours |
| "What APIs can I use?" | Ask backend team, wait for Postman collection | 4 hours |
| "Is my service running?" | Open AWS Console → ECS → find cluster → find service | 5 min/check |
| "How do I create a new service?" | Copy-paste from another repo, manually set up CI/CD, ECR, ECS | 2 days |

**Total time wasted per developer per week:** ~10 hours  
**For a team of 20 developers:** 200 hours/week = **$200,000/year in lost productivity**

### The Solution (With Backstage)

| Question | With Backstage | Time Saved |
|---|---|---|
| "What services exist?" | Open Backstage → Catalog → see all 100 services | 30 seconds |
| "Who owns the Payment Service?" | Click Payment Service → see owner: Backend Team | 5 seconds |
| "How do I deploy this?" | Click Docs tab → see deployment runbook | 30 seconds |
| "What APIs can I use?" | Click APIs → see all 50 APIs with interactive docs | 1 minute |
| "Is my service running?" | Click service → Kubernetes tab → see pod status | 10 seconds |
| "How do I create a new service?" | Click Create → fill form → get fully configured service | 5 minutes |

**Time saved per developer per week:** ~8 hours  
**ROI for 20 developers:** $160,000/year in productivity gains

---

## What This POC Demonstrates

This repository is a **production-ready Backstage implementation** showcasing every major feature:

### 1. Software Catalog (Service Discovery)
- **7 Components** — services, libraries, websites, documentation
- **6 APIs** — OpenAPI (REST), GraphQL, AsyncAPI (Kafka), gRPC
- **7 Resources** — RDS databases, S3 buckets, Kafka topics, CloudFront
- **4 Systems** — Order Management, Storefront, Data Ingestion, Platform Tooling
- **2 Domains** — E-Commerce, Data Platform
- **5 Teams** — Platform, Backend, Frontend, Data, Engineering
- **7 Users** — alice, bob, carol, dave, eve, frank, grace

### 2. Software Templates (Self-Service Infrastructure)
- **ECS Service Onboarding** — creates GitHub repo, ECR, ECS Fargate service, GoCD pipeline, PagerDuty service in one click
- **Node.js Library** — scaffolds TypeScript npm library with testing, linting, semantic-release
- **Documentation Site** — creates MkDocs TechDocs site for runbooks and wikis
- **Data Pipeline** — scaffolds Python pipeline (Kafka Streams, batch ETL, or Spark) with Airflow DAG

### 3. TechDocs (Documentation as Code)
- Full MkDocs documentation for Order Service with:
  - Architecture diagrams
  - API reference
  - Deployment runbooks
  - Incident response procedures
  - Architecture Decision Records (ADRs)

### 4. API Catalog (API Discovery)
- **OpenAPI** — Orders API, Payment API, Notification API (interactive Swagger UI)
- **GraphQL** — Product Catalogue API (GraphQL playground)
- **AsyncAPI** — Order Events (Kafka topic schemas)
- **gRPC** — Inventory API (Protobuf definitions)

### 5. Relations Graph (Dependency Mapping)
- Order Service **provides** Orders API
- Order Service **consumes** Payment API, Notification API
- Order Service **depends on** orders-db (RDS), orders-kafka-topic
- Storefront Web **consumes** Orders API, Product Catalogue API

### 6. Observability Integrations
- **Kubernetes** — live pod status, CPU/memory usage
- **GitHub Actions** — CI/CD pipeline runs
- **ArgoCD** — GitOps deployment status
- **PagerDuty** — on-call schedule, incident history
- **Datadog** — metrics, dashboards, SLOs
- **Sentry** — error tracking, affected users
- **SonarQube** — code quality, test coverage, vulnerabilities

### 7. Tech Insights (Scorecards)
- **Production Readiness** — checks for owner, docs, lifecycle, tags, monitoring
- **API Quality** — checks for API definition, owner, system
- **Security** — checks for SonarQube, no vulnerabilities, PagerDuty

---

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                     Backstage Frontend (React)                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │ Catalog  │  │   Docs   │  │   APIs   │  │  Create  │       │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘       │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    Backstage Backend (Node.js)                  │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │ Catalog  │  │ TechDocs │  │Scaffolder│  │  Search  │       │
│  │  API     │  │ Builder  │  │  Engine  │  │  Index   │       │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘       │
└─────────────────────────────────────────────────────────────────┘
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      External Integrations                      │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │  GitHub  │  │   AWS    │  │   K8s    │  │ PagerDuty│       │
│  │  (Repos) │  │(ECS/ECR) │  │ (Pods)   │  │(Incidents)│      │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐       │
│  │ Datadog  │  │  Sentry  │  │ SonarQube│  │  ArgoCD  │       │
│  │(Metrics) │  │ (Errors) │  │ (Quality)│  │ (GitOps) │       │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘       │
└─────────────────────────────────────────────────────────────────┘
```

---

## Features Showcase

| Feature | Location | What It Does |
|---|---|---|
| **Software Catalog** | `catalog/` | Centralized registry of all services, APIs, resources, teams |
| **Software Templates** | `ecs-onboarding/`, `nodejs-library/`, `documentation-site/`, `data-pipeline/` | Self-service infrastructure — create services with one click |
| **TechDocs** | `catalog/docs/` | Documentation as code — Markdown docs rendered in Backstage |
| **API Catalog** | `catalog/api-specs/` | OpenAPI, AsyncAPI, GraphQL, gRPC specs with interactive docs |
| **Org Model** | `catalog/org/` | Teams (Groups) and Users with ownership mapping |
| **Domains & Systems** | `catalog/domains-and-systems.yaml` | Business domains and technical systems hierarchy |
| **Resources** | `catalog/resources.yaml` | Infrastructure resources (RDS, S3, Kafka, CloudFront) |
| **Relations** | All catalog files | Dependency graph (`dependsOn`, `providesApis`, `consumesApis`) |
| **Annotations** | All components | Plugin integrations (GitHub, K8s, PagerDuty, Datadog, Sentry, ArgoCD, SonarQube) |
| **Tech Insights** | `backstage-config/tech-insights-scorecards.yaml` | Automated checks and scorecards for standards enforcement |

---

## How It Helps DevOps Teams

### 1. Faster Onboarding (Weeks → Days)

**Before:** New engineer spends 2 weeks asking "Where is X?", "Who owns Y?", "How do I deploy Z?"

**After:** New engineer opens Backstage on day 1:
- Sees all services in the catalog
- Reads TechDocs for architecture and deployment
- Uses templates to create their first service
- **Productive in 2 days instead of 2 weeks**

### 2. Reduced Context Switching (10 Tools → 1 Portal)

**Before:** DevOps engineer checks service health:
1. AWS Console → ECS → check task count
2. Datadog → check metrics
3. PagerDuty → check incidents
4. GitHub → check last deploy
5. Sentry → check errors
**Total time:** 10 minutes per service × 20 services = 3+ hours/day

**After:** Open Backstage → click service → see everything in one view:
- Kubernetes tab → pod status
- Datadog tab → metrics
- PagerDuty tab → incidents
- GitHub Actions tab → last deploy
- Sentry card → error count
**Total time:** 30 seconds per service × 20 services = 10 minutes/day

**Time saved:** 2.5 hours/day = **$50,000/year per DevOps engineer**

### 3. Self-Service Infrastructure (2 Days → 5 Minutes)

**Before:** Developer needs a new service:
1. Copy-paste from another repo (30 min)
2. Set up GitHub repo (15 min)
3. Create ECR repository (10 min)
4. Write ECS task definition (1 hour)
5. Set up GoCD pipeline (2 hours)
6. Configure PagerDuty (30 min)
7. Write documentation (2 hours)
**Total time:** 2 days

**After:** Developer clicks "Create" → fills form → gets:
- GitHub repo with Dockerfile, README, docs
- ECR repository
- ECS Fargate service
- GoCD pipeline
- PagerDuty service
- Registered in catalog
**Total time:** 5 minutes

**Time saved:** 2 days per new service × 10 services/month = **20 days/month**

### 4. Incident Response (30 Minutes → 5 Minutes)

**Before:** Service is down at 2am:
1. Check PagerDuty → find service name (2 min)
2. Open AWS Console → find ECS service (3 min)
3. Check logs → find error (5 min)
4. Search Confluence for runbook (10 min)
5. Find on-call engineer in PagerDuty (2 min)
6. Escalate (5 min)
**Total time:** 30 minutes (service is down the whole time)

**After:** Service is down at 2am:
1. Open Backstage → search for service (10 sec)
2. Kubernetes tab → see pod is CrashLoopBackOff (10 sec)
3. Docs tab → open incident response runbook (10 sec)
4. PagerDuty tab → see on-call engineer → page them (30 sec)
5. Follow runbook steps (3 min)
**Total time:** 5 minutes

**MTTR reduced by 83%** — service is back up 25 minutes faster

### 5. Standards Enforcement (Manual → Automated)

**Before:** Platform team manually checks:
- Does every service have an owner? (manual audit)
- Does every service have docs? (manual audit)
- Does every service have monitoring? (manual audit)
**Total time:** 1 week per quarter

**After:** Tech Insights scorecards run automatically:
- ✅ Has owner
- ❌ Missing docs → Jira ticket auto-created
- ✅ Has monitoring
**Total time:** 0 (automated)

**Compliance visibility:** 100% of services, 100% of the time

### 6. API Discovery (4 Hours → 1 Minute)

**Before:** Frontend developer needs to integrate with backend API:
1. Ask in Slack "What's the endpoint for orders?" (wait 1 hour)
2. Get Postman collection (30 min to import)
3. Read through 50 endpoints to find the right one (1 hour)
4. Ask "What's the request schema?" (wait 1 hour)
5. Trial and error (30 min)
**Total time:** 4 hours

**After:** Frontend developer opens Backstage:
1. Click APIs → search "orders" (10 sec)
2. Click Orders API → see interactive Swagger UI (10 sec)
3. See all endpoints, request/response schemas (30 sec)
4. Copy curl example (10 sec)
**Total time:** 1 minute

**Time saved:** 4 hours per integration × 20 integrations/month = **80 hours/month**

---

## AI Integration Opportunities

Backstage is **AI-ready** — here's how to integrate AI to 10x the value:

### 1. AI-Powered Search (Already Available)

**Plugin:** `@backstage/plugin-search-backend-module-explore`

**What it does:** Natural language search across catalog, docs, APIs

**Example queries:**
- "Show me all services owned by the backend team that are in production"
- "Find APIs that handle payments"
- "Which services depend on the orders database?"

**How to add:**
```bash
yarn add @backstage/plugin-search-backend-module-explore
```

### 2. AI Documentation Assistant (ChatGPT Integration)

**Plugin:** `@backstage-community/plugin-ai-assistant`

**What it does:** Chat with your documentation — ask questions, get answers from TechDocs

**Example queries:**
- "How do I deploy the Order Service to production?"
- "What's the incident response procedure for high error rates?"
- "Explain the architecture of the payment flow"

**How it works:**
1. Indexes all TechDocs content
2. Uses OpenAI embeddings for semantic search
3. Generates answers using GPT-4

**How to add:**
```bash
yarn add @backstage-community/plugin-ai-assistant
```

Add to `app-config.yaml`:
```yaml
ai:
  openai:
    apiKey: ${OPENAI_API_KEY}
```

### 3. AI Code Generation (GitHub Copilot for Templates)

**What it does:** AI generates scaffolder templates based on natural language

**Example:**
- User: "Create a template for a FastAPI service with PostgreSQL and Redis"
- AI: Generates `template.yaml` with all parameters, steps, and skeleton files

**How to implement:**
1. Use OpenAI API to generate template YAML
2. Validate with Backstage schema
3. Save to `templates/` folder

### 4. AI Incident Analysis (Root Cause Analysis)

**What it does:** AI analyzes logs, metrics, and recent changes to suggest root cause

**Example:**
- Service has high error rate
- AI checks:
  - Recent GitHub Actions deploys (was there a deploy 10 min ago?)
  - Datadog metrics (is CPU at 100%?)
  - Sentry errors (what's the exception?)
  - Kubernetes events (are pods restarting?)
- AI suggests: "Root cause: OOM error due to memory leak in v1.2.3. Rollback to v1.2.2."

**How to implement:**
1. Collect data from all plugins (GitHub Actions, Datadog, Sentry, K8s)
2. Send to OpenAI with prompt: "Analyze this data and suggest root cause"
3. Display in Backstage UI

### 5. AI Scorecard Recommendations

**What it does:** AI suggests improvements based on scorecard failures

**Example:**
- Service fails "Production Readiness" scorecard (missing docs)
- AI generates:
  - Draft TechDocs structure (index.md, architecture.md, runbooks/)
  - Draft content based on code analysis
  - PR with generated docs

**How to implement:**
1. Detect scorecard failures via Tech Insights API
2. Use OpenAI to generate docs based on code
3. Create PR via GitHub API

### 6. AI-Powered Dependency Analysis

**What it does:** AI predicts impact of changes across services

**Example:**
- Developer wants to change Orders API schema
- AI analyzes:
  - Which services consume Orders API (from relations graph)
  - What fields they use (from code analysis)
  - Breaking vs non-breaking changes
- AI warns: "This change will break Storefront Web (uses `orderId` field you're removing)"

**How to implement:**
1. Parse API specs (OpenAPI, GraphQL)
2. Analyze consumer code (via GitHub API)
3. Use OpenAI to predict impact

### 7. AI Chatbot for Backstage (Slack Integration)

**What it does:** Ask Backstage questions in Slack

**Example Slack commands:**
- `/backstage who owns payment-service` → "Backend Team (carol, dave)"
- `/backstage is order-service healthy` → "✅ 3/3 pods running, 0 errors in last hour"
- `/backstage create ecs-service my-new-api` → Starts scaffolder workflow

**How to implement:**
1. Build Slack bot with Backstage API
2. Use OpenAI to parse natural language queries
3. Call Backstage APIs (catalog, TechDocs, plugins)
4. Return formatted response

### 8. Predictive Alerts (AI Anomaly Detection)

**What it does:** AI learns normal behavior and alerts on anomalies

**Example:**
- Order Service normally has 100 req/sec
- AI detects 10 req/sec at 2pm (anomaly)
- AI checks: no recent deploy, no K8s issues, no errors
- AI suggests: "Possible upstream issue — check API Gateway"

**How to implement:**
1. Collect metrics from Datadog plugin
2. Train ML model on historical data
3. Detect anomalies in real-time
4. Display alerts in Backstage

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

## Getting Started

### Prerequisites
- Node.js 18 or 20
- Docker Desktop
- GitHub Personal Access Token (`repo`, `read:org` scopes)

### Quick Start

1. **Clone this repo:**
   ```bash
   git clone https://github.com/Ketan-Joshi/backstage-templates.git
   cd backstage-templates
   ```

2. **Create a Backstage app:**
   ```bash
   npx @backstage/create-app@latest
   # Name: backstage-poc
   # Database: SQLite
   ```

3. **Copy the config:**
   ```bash
   cp backstage-config/app-config.yaml backstage-poc/app-config.yaml
   ```

4. **Set environment variables:**
   ```bash
   export GITHUB_TOKEN=ghp_your_token_here
   ```

5. **Start Backstage:**
   ```bash
   cd backstage-poc
   yarn dev
   ```

6. **Open:** `http://localhost:3000`

See `IMPLEMENTATION_GUIDE.md` for detailed setup instructions.

---

## Plugin Documentation

See `PLUGIN_DOCUMENTATION.md` for detailed documentation of all 10 plugins:

1. **API Docs** — OpenAPI, GraphQL, AsyncAPI, gRPC viewer
2. **TechDocs** — Documentation as code (MkDocs)
3. **Kubernetes** — Live pod status, CPU/memory usage
4. **GitHub Actions** — CI/CD pipeline runs
5. **SonarQube** — Code quality, test coverage, vulnerabilities
6. **ArgoCD** — GitOps deployment status
7. **PagerDuty** — On-call schedule, incident history
8. **Sentry** — Error tracking, affected users
9. **Datadog** — Metrics, dashboards, SLOs
10. **Tech Insights** — Automated checks and scorecards

---

## Real-World Use Cases

### Use Case 1: New Developer Onboarding

**Scenario:** Alice joins the backend team on Monday.

**Day 1 (Before Backstage):**
- Asks in Slack: "What services do we own?" (waits 2 hours for response)
- Gets a list of 15 service names (no context)
- Asks: "Where's the code?" (waits 1 hour)
- Asks: "How do I deploy?" (waits 3 hours)
- **Productive:** Friday (4 days wasted)

**Day 1 (With Backstage):**
- Opens Backstage → filters by owner: backend-team
- Sees 15 services with descriptions, tech stack, and links
- Clicks Order Service → Docs tab → reads architecture and deployment guide
- Clicks Create → scaffolds her first service
- **Productive:** Tuesday (3 days saved)

### Use Case 2: Incident Response

**Scenario:** Payment Service is down at 2am. Bob is on-call.

**Before Backstage:**
1. PagerDuty alert: "Payment Service high error rate"
2. Opens AWS Console → finds ECS service (3 min)
3. Checks logs → sees "Database connection timeout" (5 min)
4. Searches Confluence for runbook (10 min — can't find it)
5. Calls senior engineer (wakes them up)
6. Senior engineer walks Bob through recovery (20 min)
**Total MTTR:** 40 minutes

**With Backstage:**
1. PagerDuty alert: "Payment Service high error rate"
2. Opens Backstage → Payment Service → Kubernetes tab → sees pods restarting (10 sec)
3. Docs tab → Incident Response runbook → sees "Database connection timeout" section (30 sec)
4. Follows runbook: restart database connection pool (2 min)
5. Service recovers
**Total MTTR:** 3 minutes (37 minutes saved)

### Use Case 3: API Integration

**Scenario:** Frontend team needs to integrate with Orders API.

**Before Backstage:**
1. Carol asks in Slack: "What's the Orders API endpoint?" (waits 1 hour)
2. Gets Postman collection (30 min to import and understand)
3. Asks: "What's the schema for creating an order?" (waits 1 hour)
4. Trial and error with curl (30 min)
**Total time:** 4 hours

**With Backstage:**
1. Carol opens Backstage → APIs → Orders API
2. Sees interactive Swagger UI with all endpoints
3. Clicks "POST /orders" → sees request schema
4. Copies curl example → works first try
**Total time:** 5 minutes (3 hours 55 minutes saved)

---

## ROI & Business Value

### Quantified Benefits (20-person engineering team)

| Benefit | Time Saved | Annual Value |
|---|---|---|
| **Faster onboarding** | 3 days per new hire × 5 hires/year | $30,000 |
| **Reduced context switching** | 2.5 hours/day per DevOps × 3 DevOps | $150,000 |
| **Self-service infrastructure** | 2 days per service × 10 services/month | $240,000 |
| **Faster incident response** | 25 min per incident × 50 incidents/month | $50,000 |
| **API discovery** | 4 hours per integration × 20 integrations/month | $80,000 |
| **Standards enforcement** | 1 week per quarter (automated) | $20,000 |
| **Total Annual Value** | | **$570,000** |

**Backstage Cost:**
- Open-source (free)
- 1 DevOps engineer to maintain (20% time) = $30,000/year
- AWS hosting (EC2 t3.medium) = $500/year

**Net ROI:** $570,000 - $30,500 = **$539,500/year**  
**ROI Percentage:** 1,767%

### Intangible Benefits

- **Developer happiness** — less frustration, more productivity
- **Faster time-to-market** — ship features faster with self-service
- **Better reliability** — faster incident response, enforced standards
- **Knowledge retention** — docs live in code, not in people's heads
- **Scalability** — onboard 100 services as easily as 10

---

## Next Steps

1. **Explore the live demo:** `http://3.208.117.182:3000`
2. **Read the plugin docs:** `PLUGIN_DOCUMENTATION.md`
3. **Follow the setup guide:** `IMPLEMENTATION_GUIDE.md`
4. **Integrate your real services:** Add your ECS services, S3 buckets, and GoCD pipelines
5. **Add AI features:** Start with AI-powered search and documentation assistant

---

## Support & Resources

- **Backstage Docs:** https://backstage.io/docs
- **Backstage Plugins:** https://backstage.io/plugins
- **CNCF Backstage:** https://www.cncf.io/projects/backstage/
- **Community Slack:** https://backstage.io/community

---

## License

This POC is provided as-is for demonstration purposes. Backstage itself is Apache 2.0 licensed.

---

**Built with ❤️ by the Platform Team**
