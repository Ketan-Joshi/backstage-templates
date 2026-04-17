# Backstage Plugins — Complete Documentation

This guide explains every plugin in the POC: what it does, why you need it, and real-world use cases for developers and DevOps teams.

---

## 1. API Docs Plugin

**Status:** Built-in (no install needed)

### What it does
Renders API specifications directly in Backstage. Supports OpenAPI (REST), GraphQL, AsyncAPI (Kafka/events), and gRPC/Protobuf.

### What problem it solves
**Before:** Developers ask "What APIs exist?" and "How do I call this API?" — answers are scattered across Confluence, Postman collections, and Slack threads.

**After:** Every API is registered in the catalog with interactive documentation. Click an API → see the full spec with request/response examples.

### Use cases

| Persona | Use case |
|---|---|
| **Backend Developer** | Discovers the Payment API exists, sees all endpoints, request schemas, and response codes without asking anyone |
| **Frontend Developer** | Finds the Product Catalogue GraphQL API, sees the schema, and knows exactly what queries are available |
| **Data Engineer** | Discovers the Kafka topic schema (AsyncAPI) for order events — knows what fields to expect in the stream |
| **Mobile Developer** | Sees the gRPC Inventory API protobuf definition — generates client code automatically |

### What you see in Backstage
- **APIs page** — list of all APIs across the org
- **API detail page** — interactive Swagger UI for REST APIs, GraphQL playground, AsyncAPI viewer
- **Component page → API tab** — shows which APIs this service provides or consumes

### Real-world value
- **Reduces onboarding time** — new developers find APIs in 30 seconds instead of 30 minutes of Slack questions
- **Prevents duplicate APIs** — before building a new API, search the catalog to see if it already exists
- **Self-service integration** — frontend teams integrate with backend APIs without meetings

---

## 2. TechDocs Plugin

**Status:** Built-in (no install needed)

### What it does
Renders Markdown documentation (written in MkDocs format) directly inside Backstage. Docs live in the same Git repo as the code.

### What problem it solves
**Before:** Documentation is scattered across Confluence, Google Docs, GitHub wikis, and READMEs. It's always out of date because it's separate from the code.

**After:** Docs live in the `docs/` folder of each service repo. When you push code, docs update automatically. Backstage renders them beautifully.

### Use cases

| Persona | Use case |
|---|---|
| **On-call Engineer** | Service is down at 2am. Opens Backstage → Docs tab → Incident Response runbook → follows the steps to recover |
| **New Team Member** | Joins the team, clicks Order Service → Docs tab → sees architecture diagram, getting started guide, and how to deploy |
| **Platform Team** | Writes a "How to Deploy to ECS" guide once in TechDocs — every team sees it in the Platform Tooling system docs |
| **Architect** | Documents an Architecture Decision Record (ADR) for "Why we chose PostgreSQL" — lives forever in the service's docs/ folder |

### What you see in Backstage
- **Component page → Docs tab** — full documentation site with navigation, search, and diagrams
- **Search** — searches across all TechDocs content

### Real-world value
- **Docs stay up to date** — they're in the same repo as code, reviewed in PRs
- **No context switching** — read docs in the same portal where you view the service
- **Runbooks at your fingertips** — on-call engineers don't hunt for runbooks in Slack pins

### What to document
- Architecture diagrams
- Getting started / local development
- Deployment runbooks
- Incident response procedures
- ADRs (Architecture Decision Records)
- API usage examples

---

## 3. Kubernetes Plugin

**Install:** `yarn add @backstage/plugin-kubernetes` + backend

### What it does
Shows live Kubernetes resources (pods, deployments, services, ingresses) for each component. Connects to your K8s clusters and pulls real-time data.

### What problem it solves
**Before:** Developer asks "Is my service running?" → opens AWS console → navigates to EKS → finds the cluster → finds the namespace → finds the deployment → checks pod status. Takes 2 minutes.

**After:** Click the service in Backstage → Kubernetes tab → see pod count, status, restarts, and errors in 5 seconds.

### Use cases

| Persona | Use case |
|---|---|
| **Developer** | Deploys a new version, opens Backstage → K8s tab → sees new pods starting, old pods terminating — confirms rollout is healthy |
| **On-call Engineer** | Gets a PagerDuty alert, opens Backstage → K8s tab → sees 3 pods are CrashLoopBackOff — clicks pod → sees logs |
| **DevOps Engineer** | Checks resource usage across all services — sees which ones are over-provisioned (requested 2GB, using 200MB) |
| **Manager** | Wants to know "How many services are running in production?" — filters catalog by lifecycle=production, sees K8s tab on each |

### What you see in Backstage
- **Component page → Kubernetes tab:**
  - Pod count (running / desired)
  - Pod status (Running, Pending, CrashLoopBackOff)
  - CPU and memory usage
  - Recent events (scaled up, image pulled, etc.)
  - Links to pod logs

### Real-world value
- **Faster debugging** — see pod status without leaving Backstage
- **Visibility for non-DevOps** — developers see their own service health without kubectl access
- **Multi-cluster support** — one view across dev, staging, and production clusters

### Configuration
Annotate components with:
```yaml
annotations:
  backstage.io/kubernetes-id: my-service
  backstage.io/kubernetes-namespace: production
  backstage.io/kubernetes-label-selector: app=my-service
```

---

## 4. GitHub Actions Plugin

**Install:** `yarn add @backstage-community/plugin-github-actions`

### What it does
Shows GitHub Actions workflow runs (CI/CD pipelines) for each component. See build status, test results, and deployment history.

### What problem it solves
**Before:** Developer pushes code, opens GitHub → Actions tab → finds the workflow → checks if tests passed. Repeat for every service.

**After:** Open the service in Backstage → CI/CD tab → see the last 10 workflow runs with status, duration, and links to logs.

### Use cases

| Persona | Use case |
|---|---|
| **Developer** | Pushes a PR, opens Backstage → sees the CI workflow is running → waits for green checkmark before merging |
| **Tech Lead** | Reviews all services owned by the team → sees which ones have failing CI — investigates |
| **Release Manager** | Checks deployment status across 20 services — sees which ones deployed successfully to production today |
| **Security Team** | Sees which services have security scan workflows enabled — identifies gaps |

### What you see in Backstage
- **Component page → CI/CD tab:**
  - Recent workflow runs (build, test, deploy)
  - Status (success, failure, in progress)
  - Duration
  - Triggered by (commit, PR, manual)
  - Link to GitHub Actions logs

### Real-world value
- **Single pane of glass** — see CI status for all services without opening 50 GitHub tabs
- **Faster feedback** — developers see test failures immediately
- **Deployment tracking** — know when the last production deploy happened

### Configuration
Annotate components with:
```yaml
annotations:
  github.com/project-slug: your-org/your-repo
```

---

## 5. SonarQube Plugin

**Install:** `yarn add @backstage/plugin-sonarqube` + backend

### What it does
Shows code quality metrics from SonarQube: bugs, vulnerabilities, code smells, test coverage, and technical debt.

### What problem it solves
**Before:** Code quality is invisible. Developers don't know if their service has security vulnerabilities or low test coverage until a security audit or production incident.

**After:** Every service shows a SonarQube card with quality gate status, coverage %, and critical issues.

### Use cases

| Persona | Use case |
|---|---|
| **Developer** | Opens their service → sees "12 bugs, 3 vulnerabilities" → clicks through to SonarQube to fix them |
| **Tech Lead** | Reviews all team services → sees one has 20% test coverage → schedules time to write tests |
| **Security Team** | Filters catalog by "has vulnerabilities" → creates Jira tickets for each team |
| **Architect** | Enforces quality gates — services with failing SonarQube checks can't deploy to production |

### What you see in Backstage
- **Component page → Overview tab → SonarQube card:**
  - Quality gate status (passed / failed)
  - Bugs, vulnerabilities, code smells count
  - Test coverage %
  - Technical debt (time to fix all issues)
  - Link to full SonarQube report

### Real-world value
- **Shift-left security** — developers see vulnerabilities before code review
- **Visibility for managers** — see code quality across the entire org
- **Enforce standards** — block deploys if quality gate fails

### Configuration
Annotate components with:
```yaml
annotations:
  sonarqube.org/project-key: your-org_your-service
```

---

## 6. ArgoCD Plugin

**Install:** `yarn add @roadiehq/backstage-plugin-argo-cd` + backend

### What it does
Shows ArgoCD application status: sync status, health, last deployment, and Git commit deployed.

### What problem it solves
**Before:** Developer asks "What version is running in production?" → opens ArgoCD UI → finds the app → checks the Git commit SHA → goes to GitHub to see what changed.

**After:** Open the service in Backstage → ArgoCD tab → see the deployed commit, sync status, and health in one view.

### Use cases

| Persona | Use case |
|---|---|
| **Developer** | Merges a PR, opens Backstage → ArgoCD tab → sees ArgoCD syncing the new version to production |
| **On-call Engineer** | Service is unhealthy, opens Backstage → ArgoCD tab → sees "Degraded" status → clicks through to ArgoCD for details |
| **Release Manager** | Checks which Git commit is deployed in production across 30 services — sees it all in Backstage |
| **Auditor** | Needs to know "What was deployed on March 15?" — checks ArgoCD history in Backstage |

### What you see in Backstage
- **Component page → ArgoCD tab:**
  - Sync status (Synced, OutOfSync, Syncing)
  - Health status (Healthy, Degraded, Progressing)
  - Last sync time
  - Git commit SHA deployed
  - Link to ArgoCD UI

### Real-world value
- **GitOps visibility** — see what's deployed without opening ArgoCD
- **Faster incident response** — see if a recent deploy caused the issue
- **Audit trail** — know exactly what version is running in production

### Configuration
Annotate components with:
```yaml
annotations:
  argocd/app-name: my-service-production
```

---

## 7. PagerDuty Plugin

**Install:** `yarn add @pagerduty/backstage-plugin` + backend

### What it does
Shows PagerDuty incidents and on-call schedule for each service. See who's on-call, recent incidents, and incident history.

### What problem it solves
**Before:** Service is down, developer asks "Who's on-call for the Payment Service?" → opens PagerDuty → searches for the service → finds the on-call person → pages them.

**After:** Open Payment Service in Backstage → PagerDuty tab → see who's on-call and recent incidents.

### Use cases

| Persona | Use case |
|---|---|
| **Developer** | Sees an error in logs, opens Backstage → PagerDuty tab → sees the on-call engineer → Slack DMs them |
| **On-call Engineer** | Gets paged, opens Backstage → PagerDuty tab → sees this is the 5th incident this week for this service → escalates |
| **Manager** | Reviews incident count across all services → sees Order Service has 20 incidents this month → schedules a reliability sprint |
| **SRE** | Tracks MTTR (mean time to resolve) across services — identifies which teams need help |

### What you see in Backstage
- **Component page → PagerDuty tab:**
  - Current on-call engineer (name, photo, contact)
  - Recent incidents (open, acknowledged, resolved)
  - Incident count (last 7 days, 30 days)
  - Link to PagerDuty service

### Real-world value
- **Faster escalation** — know who to page without searching
- **Incident visibility** — see incident trends across services
- **Accountability** — every service has a clear on-call owner

### Configuration
Annotate components with:
```yaml
annotations:
  pagerduty.com/service-id: PXXXXXX
```

---

## 8. Sentry Plugin

**Install:** `yarn add @backstage/plugin-sentry`

### What it does
Shows Sentry error tracking data: error count, affected users, and recent exceptions.

### What problem it solves
**Before:** Service has errors in production, but no one notices until a customer complains. Developers don't check Sentry regularly.

**After:** Every service shows a Sentry card in Backstage. Errors are visible to the whole team.

### Use cases

| Persona | Use case |
|---|---|
| **Developer** | Opens their service in Backstage → sees "127 errors in the last 24 hours" → clicks through to Sentry to investigate |
| **Product Manager** | Sees "500 users affected by errors" → prioritizes a bug fix sprint |
| **On-call Engineer** | Gets paged for high error rate → opens Backstage → Sentry tab → sees the exact exception and stack trace |
| **QA Engineer** | After a release, checks Sentry card → sees new error types introduced → files bugs |

### What you see in Backstage
- **Component page → Overview tab → Sentry card:**
  - Error count (last 24 hours)
  - Affected users
  - Recent exceptions (with stack traces)
  - Link to Sentry project

### Real-world value
- **Proactive error detection** — see errors before customers complain
- **Visibility for non-engineers** — PMs see error impact on users
- **Faster debugging** — stack traces right in Backstage

### Configuration
Annotate components with:
```yaml
annotations:
  sentry.io/project-slug: my-service
```

---

## 9. Datadog Plugin

**Install:** `yarn add @roadiehq/backstage-plugin-datadog`

### What it does
Shows Datadog dashboards, SLOs, and monitors for each service. See metrics, logs, and APM traces.

### What problem it solves
**Before:** Developer needs to check service health → opens Datadog → searches for the dashboard → checks metrics. Repeat for every service.

**After:** Open the service in Backstage → Datadog tab → see the dashboard embedded, or click through to Datadog.

### Use cases

| Persona | Use case |
|---|---|
| **Developer** | Deploys a new version, opens Backstage → Datadog tab → sees latency spiked → rolls back |
| **SRE** | Checks SLO compliance across all services → sees Order Service is at 99.5% (below 99.9% target) → investigates |
| **On-call Engineer** | Gets paged for high latency → opens Backstage → Datadog tab → sees CPU is at 100% → scales up |
| **Manager** | Reviews service health across the org → sees which services are meeting SLOs |

### What you see in Backstage
- **Component page → Datadog tab:**
  - Embedded dashboard (graphs for latency, error rate, throughput)
  - SLO status (% uptime, error budget remaining)
  - Recent monitor alerts
  - Link to full Datadog dashboard

### Real-world value
- **Single pane of glass** — see metrics without opening Datadog
- **SLO visibility** — track reliability goals across services
- **Faster incident response** — see metrics immediately

### Configuration
Annotate components with:
```yaml
annotations:
  datadoghq.com/dashboard-url: https://app.datadoghq.com/dashboard/abc-123
  datadoghq.com/slo-url: https://app.datadoghq.com/slo/abc-123
```

---

## 10. Tech Insights (Scorecards) Plugin

**Install:** `yarn add @backstage/plugin-tech-insights` + backend

### What it does
Runs automated checks on every service and shows a scorecard. Examples: "Has an owner?", "Has TechDocs?", "Has tests?", "Deployed in the last 30 days?".

### What problem it solves
**Before:** No one knows which services follow best practices. Some services have no owner, no docs, no tests. You discover this during an incident.

**After:** Every service shows a scorecard. Red = failing checks, green = passing. Managers see compliance across the org.

### Use cases

| Persona | Use case |
|---|---|
| **Tech Lead** | Reviews all team services → sees 3 have no TechDocs → assigns tasks to write docs |
| **Platform Team** | Enforces standards — services must pass "Production Readiness" scorecard before deploying to prod |
| **Manager** | Tracks org-wide metrics — "80% of services have an owner, 60% have docs" → sets goals to improve |
| **Auditor** | Checks compliance — "All PCI services must have SonarQube enabled" → filters by scorecard |

### What you see in Backstage
- **Component page → Overview tab → Scorecard card:**
  - Checks (green checkmark or red X)
  - Examples:
    - ✅ Has an owner
    - ✅ Has TechDocs
    - ❌ Has lifecycle set
    - ✅ Has at least one tag
    - ❌ Deployed in last 30 days
- **Tech Insights page** — org-wide scorecard summary

### Real-world value
- **Enforce standards** — make best practices visible and measurable
- **Gamification** — teams compete to get all green checkmarks
- **Identify gaps** — see which services need attention

### Example scorecards
| Scorecard | Checks |
|---|---|
| **Production Readiness** | Has owner, has docs, has lifecycle, has tags, has monitoring |
| **Security** | Has SonarQube, no critical vulnerabilities, has PagerDuty, has on-call |
| **API Quality** | Has API definition, has owner, belongs to a system |

### Configuration
Define checks in `app-config.yaml`:
```yaml
techInsights:
  factRetrievers:
    entityOwnershipFactRetriever:
      cadence: '*/15 * * * *'
```

---

## Summary Table — When to Use Each Plugin

| Plugin | Primary user | When you need it |
|---|---|---|
| **API Docs** | Developers | You have 5+ APIs and developers ask "What APIs exist?" |
| **TechDocs** | Everyone | Documentation is scattered and out of date |
| **Kubernetes** | Developers, DevOps | You run services on Kubernetes and want visibility |
| **GitHub Actions** | Developers, Release Managers | You use GitHub Actions for CI/CD |
| **SonarQube** | Developers, Security | You want to enforce code quality and security |
| **ArgoCD** | DevOps, SREs | You use GitOps and want deployment visibility |
| **PagerDuty** | On-call Engineers | You want to see who's on-call and incident history |
| **Sentry** | Developers, PMs | You want to track production errors |
| **Datadog** | SREs, Developers | You want to see metrics and SLOs |
| **Tech Insights** | Managers, Platform Teams | You want to enforce standards and track compliance |

---

## The Big Picture — Why These Plugins Matter

### Without plugins
Backstage is just a catalog — a list of services with descriptions. Useful, but limited.

### With plugins
Backstage becomes a **developer portal** — a single pane of glass for:
- **Discovery** — What services exist? (Catalog)
- **Documentation** — How does it work? (TechDocs)
- **APIs** — How do I integrate? (API Docs)
- **Health** — Is it running? (Kubernetes, Datadog)
- **Quality** — Is the code good? (SonarQube, Tech Insights)
- **Incidents** — Who's on-call? (PagerDuty, Sentry)
- **Deployments** — What's deployed? (ArgoCD, GitHub Actions)

### ROI for the organization
- **Faster onboarding** — new developers find everything in one place (weeks → days)
- **Reduced context switching** — no more opening 10 tools to check service health
- **Enforced standards** — scorecards make best practices visible and measurable
- **Better incident response** — on-call engineers have all context in one portal
- **Visibility for leadership** — managers see org-wide metrics (service health, code quality, incident trends)

---

## Next Steps

1. **Start with the built-ins** — API Docs and TechDocs work out of the box
2. **Add observability** — Kubernetes, Datadog, Sentry (if you use them)
3. **Add CI/CD visibility** — GitHub Actions, ArgoCD
4. **Enforce standards** — Tech Insights scorecards
5. **Integrate incident management** — PagerDuty

Each plugin takes 15–30 minutes to install and configure. The value compounds — the more plugins you add, the more Backstage becomes the single source of truth.
