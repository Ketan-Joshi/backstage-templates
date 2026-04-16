# Implementation Guide — Backstage POC

This guide walks you through every step to get this POC running locally,
from zero to a fully working Backstage portal with all features visible.

---

## Prerequisites

Install these before starting:

| Tool | Version | Check |
|---|---|---|
| Node.js (Active LTS) | 18 or 20 | `node --version` |
| npm | 9+ | `npm --version` |
| Docker Desktop | any recent | `docker --version` |
| Git | any | `git --version` |
| Python 3 + pip | 3.9+ | `python3 --version` |

> **macOS shortcut:** `brew install node python3` then install Docker Desktop from docker.com

---

## Phase 1 — Create the Backstage App

### Step 1.1 — Scaffold a new Backstage app

Run this **outside** this repository (e.g. in `~/projects`):

```bash
npx @backstage/create-app@latest
```

When prompted:
- **App name:** `backstage-poc` (or anything you like)
- **Database:** choose `SQLite` for local dev (no setup needed)

This creates a `backstage-poc/` folder. It takes 2–5 minutes.

```
backstage-poc/
├── app-config.yaml          ← main config (you will edit this)
├── packages/
│   ├── app/                 ← React frontend
│   │   └── src/
│   │       ├── App.tsx      ← plugin wiring
│   │       └── components/
│   └── backend/             ← Node.js backend
│       └── src/
│           └── index.ts     ← backend plugin wiring
└── package.json
```

### Step 1.2 — Verify it starts

```bash
cd backstage-poc
yarn dev
```

Open http://localhost:3000 — you should see the default Backstage UI.
Stop it with `Ctrl+C` before continuing.

---

## Phase 2 — Push this POC repo to GitHub

The catalog entities reference GitHub URLs, so the repo must be on GitHub.

```bash
# In THIS repository (backstage-poc-catalog)
git remote add origin https://github.com/YOUR-ORG/YOUR-REPO-NAME.git
git push -u origin main
```

Then update every `example-org/backstage-poc` reference in the catalog files
to match your actual org/repo. The key file is:

```bash
# catalog/all.yaml — update the target URLs
# backstage-config/app-config.yaml — update catalog.locations targets
```

Quick find-and-replace:
```bash
# Run from the root of this repo
find . -name "*.yaml" -o -name "*.md" | xargs sed -i '' \
  's|example-org/backstage-poc|YOUR-ORG/YOUR-REPO|g'
```

---

## Phase 3 — Configure app-config.yaml

Open `backstage-poc/app-config.yaml` in your editor and **replace its contents**
with the following (or merge section by section):

### 3.1 — Base config + catalog locations

```yaml
app:
  title: Example Corp Developer Portal
  baseUrl: http://localhost:3000

organization:
  name: Example Corp

backend:
  baseUrl: http://localhost:7007
  listen:
    port: 7007
  cors:
    origin: http://localhost:3000
    methods: [GET, HEAD, PATCH, POST, PUT, DELETE]
    credentials: true
  database:
    client: better-sqlite3
    connection: ':memory:'

catalog:
  rules:
    - allow:
        - Component
        - API
        - Resource
        - System
        - Domain
        - Group
        - User
        - Template
        - Location

  locations:
    # ← Replace YOUR-ORG/YOUR-REPO with your actual GitHub org/repo
    - type: url
      target: https://github.com/YOUR-ORG/YOUR-REPO/blob/main/catalog/all.yaml
      rules:
        - allow: [Component, API, Resource, System, Domain, Group, User, Location]

    - type: url
      target: https://github.com/YOUR-ORG/YOUR-REPO/blob/main/ecs-onboarding/template.yaml
      rules:
        - allow: [Template]

    - type: url
      target: https://github.com/YOUR-ORG/YOUR-REPO/blob/main/nodejs-library/template.yaml
      rules:
        - allow: [Template]

    - type: url
      target: https://github.com/YOUR-ORG/YOUR-REPO/blob/main/documentation-site/template.yaml
      rules:
        - allow: [Template]

    - type: url
      target: https://github.com/YOUR-ORG/YOUR-REPO/blob/main/data-pipeline/template.yaml
      rules:
        - allow: [Template]
```

### 3.2 — GitHub integration (required for catalog + scaffolder)

Create a GitHub Personal Access Token:
1. Go to https://github.com/settings/tokens
2. Click **Generate new token (classic)**
3. Scopes needed: `repo`, `read:org`, `read:user`
4. Copy the token

Add to `app-config.yaml`:

```yaml
integrations:
  github:
    - host: github.com
      token: ${GITHUB_TOKEN}
```

Create a `.env` file in `backstage-poc/` (never commit this):

```bash
GITHUB_TOKEN=ghp_your_token_here
```

### 3.3 — TechDocs

```yaml
techdocs:
  builder: 'local'
  generator:
    runIn: 'docker'   # requires Docker Desktop running
  publisher:
    type: 'local'
```

Install the TechDocs CLI and MkDocs (needed for local generation):

```bash
pip3 install mkdocs-techdocs-core
```

### 3.4 — Auth (optional for POC, but enables GitHub login)

Create a GitHub OAuth App:
1. Go to https://github.com/settings/developers → OAuth Apps → New OAuth App
2. **Homepage URL:** `http://localhost:3000`
3. **Callback URL:** `http://localhost:7007/api/auth/github/handler/frame`
4. Copy Client ID and Client Secret

Add to `.env`:
```bash
GITHUB_CLIENT_ID=your_client_id
GITHUB_CLIENT_SECRET=your_client_secret
```

Add to `app-config.yaml`:
```yaml
auth:
  environment: development
  providers:
    github:
      development:
        clientId: ${GITHUB_CLIENT_ID}
        clientSecret: ${GITHUB_CLIENT_SECRET}
        signIn:
          resolvers:
            - resolver: usernameMatchingUserEntityName
```
```yaml
scaffolder:
  defaultEnvironment: development
```

---

## Phase 4 — Install Plugins

All commands run from inside `backstage-poc/`.

### 4.1 — API Docs plugin (OpenAPI/AsyncAPI/GraphQL viewer)

```bash
yarn --cwd packages/app add @backstage/plugin-api-docs
```

Edit `packages/app/src/components/catalog/EntityPage.tsx` — add the API tab:

```tsx
// Add this import at the top
import {
  ApiDefinitionCard,
  ConsumedApisCard,
  ProvidedApisCard,
  ApiExplorerPage,
} from '@backstage/plugin-api-docs';

// In the apiPage const, it's already wired in the default app.
// For the serviceEntityPage, add:
<EntityLayout.Route path="/api" title="API">
  <Grid container spacing={3} alignItems="stretch">
    <Grid item md={6}>
      <ProvidedApisCard />
    </Grid>
    <Grid item md={6}>
      <ConsumedApisCard />
    </Grid>
  </Grid>
</EntityLayout.Route>
```

### 4.2 — TechDocs plugin

Already included in the default app. No extra install needed.
Verify `packages/app/src/App.tsx` has:

```tsx
import { TechDocsPage } from '@backstage/plugin-techdocs';
// and in routes:
<Route path="/docs" element={<TechDocsPage />} />
```

### 4.3 — Kubernetes plugin

```bash
# Frontend
yarn --cwd packages/app add @backstage/plugin-kubernetes

# Backend
yarn --cwd packages/backend add @backstage/plugin-kubernetes-backend
```

**Frontend** — `packages/app/src/components/catalog/EntityPage.tsx`:

```tsx
import { EntityKubernetesContent } from '@backstage/plugin-kubernetes';

// Add to serviceEntityPage:
<EntityLayout.Route path="/kubernetes" title="Kubernetes">
  <EntityKubernetesContent refreshIntervalMs={30000} />
</EntityLayout.Route>
```

**Backend** — `packages/backend/src/index.ts`:

```ts
// Add this line with the other backend.add() calls:
backend.add(import('@backstage/plugin-kubernetes-backend'));
```

Add to `app-config.yaml` (only if you have a real cluster; skip for pure POC):

```yaml
kubernetes:
  serviceLocatorMethod:
    type: 'multiTenant'
  clusterLocatorMethods:
    - type: 'config'
      clusters:
        - url: ${K8S_CLUSTER_URL}
          name: production
          authProvider: 'serviceAccount'
          serviceAccountToken: ${K8S_SERVICE_ACCOUNT_TOKEN}
          caData: ${K8S_CA_DATA}
```

### 4.4 — GitHub Actions plugin

```bash
yarn --cwd packages/app add @backstage-community/plugin-github-actions
```

`packages/app/src/components/catalog/EntityPage.tsx`:

```tsx
import { EntityGithubActionsContent, isGithubActionsAvailable } from '@backstage-community/plugin-github-actions';

// Add to serviceEntityPage:
<EntityLayout.Route path="/github-actions" title="GitHub Actions"
  if={isGithubActionsAvailable}>
  <EntityGithubActionsContent />
</EntityLayout.Route>
```

### 4.5 — SonarQube plugin

```bash
# Frontend
yarn --cwd packages/app add @backstage/plugin-sonarqube

# Backend
yarn --cwd packages/backend add @backstage/plugin-sonarqube-backend
```

**Frontend** — add to `EntityPage.tsx`:

```tsx
import { EntitySonarQubeCard, isSonarQubeAvailable } from '@backstage/plugin-sonarqube';

// Add to overviewContent:
<EntitySwitch>
  <EntitySwitch.Case if={isSonarQubeAvailable}>
    <Grid item md={6}>
      <EntitySonarQubeCard variant="gridItem" />
    </Grid>
  </EntitySwitch.Case>
</EntitySwitch>
```

**Backend** — `packages/backend/src/index.ts`:

```ts
backend.add(import('@backstage/plugin-sonarqube-backend'));
```

Add to `app-config.yaml`:
```yaml
sonarqube:
  baseUrl: https://sonarqube.example.com
  apiKey: ${SONARQUBE_TOKEN}
```

### 4.6 — ArgoCD plugin

```bash
yarn --cwd packages/app add @roadiehq/backstage-plugin-argo-cd
yarn --cwd packages/backend add @roadiehq/backstage-plugin-argo-cd-backend
```

**Frontend** — `EntityPage.tsx`:

```tsx
import { EntityArgoCDOverviewCard, isArgocdAvailable } from '@roadiehq/backstage-plugin-argo-cd';

// Add to overviewContent:
<EntitySwitch>
  <EntitySwitch.Case if={isArgocdAvailable}>
    <Grid item md={6}>
      <EntityArgoCDOverviewCard />
    </Grid>
  </EntitySwitch.Case>
</EntitySwitch>
```

**Backend** — `packages/backend/src/index.ts`:

```ts
backend.add(import('@roadiehq/backstage-plugin-argo-cd-backend'));
```

### 4.7 — PagerDuty plugin

```bash
yarn --cwd packages/app add @pagerduty/backstage-plugin
yarn --cwd packages/backend add @pagerduty/backstage-plugin-backend
```

**Frontend** — `EntityPage.tsx`:

```tsx
import { EntityPagerDutyCard, isPagerDutyAvailable } from '@pagerduty/backstage-plugin';

// Add to overviewContent:
<EntitySwitch>
  <EntitySwitch.Case if={isPagerDutyAvailable}>
    <Grid item md={6}>
      <EntityPagerDutyCard />
    </Grid>
  </EntitySwitch.Case>
</EntitySwitch>
```

**Backend** — `packages/backend/src/index.ts`:

```ts
backend.add(import('@pagerduty/backstage-plugin-backend'));
```

Add to `app-config.yaml`:
```yaml
pagerduty:
  apiToken: ${PAGERDUTY_TOKEN}
```

### 4.8 — Sentry plugin

```bash
yarn --cwd packages/app add @backstage/plugin-sentry
```

**Frontend** — `EntityPage.tsx`:

```tsx
import { EntitySentryCard, isSentryAvailable } from '@backstage/plugin-sentry';

// Add to overviewContent:
<EntitySwitch>
  <EntitySwitch.Case if={isSentryAvailable}>
    <Grid item md={6}>
      <EntitySentryCard />
    </Grid>
  </EntitySwitch.Case>
</EntitySwitch>
```

Add to `app-config.yaml`:
```yaml
sentry:
  organization: your-sentry-org-slug
```

### 4.9 — Datadog plugin

```bash
yarn --cwd packages/app add @roadiehq/backstage-plugin-datadog
```

**Frontend** — `EntityPage.tsx`:

```tsx
import { EntityDatadogContent, isDatadogAvailable } from '@roadiehq/backstage-plugin-datadog';

// Add as a tab:
<EntityLayout.Route path="/datadog" title="Datadog" if={isDatadogAvailable}>
  <EntityDatadogContent />
</EntityLayout.Route>
```

### 4.10 — Tech Insights / Scorecards

```bash
yarn --cwd packages/app add @backstage/plugin-tech-insights
yarn --cwd packages/backend add @backstage/plugin-tech-insights-backend \
  @backstage/plugin-tech-insights-backend-module-jsonfc
```

**Frontend** — `packages/app/src/App.tsx`:

```tsx
import { TechInsightsPage } from '@backstage/plugin-tech-insights';

// Add route:
<Route path="/tech-insights" element={<TechInsightsPage />} />
```

Also add the scorecard card to `EntityPage.tsx`:

```tsx
import { EntityTechInsightsScorecardCard } from '@backstage/plugin-tech-insights';

// Add to overviewContent:
<Grid item md={6}>
  <EntityTechInsightsScorecardCard
    title="Production Readiness"
    checksId={['has-owner', 'has-description', 'has-techdocs', 'has-lifecycle', 'has-tags']}
  />
</Grid>
```

**Backend** — `packages/backend/src/index.ts`:

```ts
backend.add(import('@backstage/plugin-tech-insights-backend'));
backend.add(import('@backstage/plugin-tech-insights-backend-module-jsonfc'));
```

### 4.11 — Org plugin (people/teams pages)

Already included in default app. Verify `App.tsx` has:

```tsx
import { OrgPage } from '@backstage/plugin-org';
<Route path="/org" element={<OrgPage />} />
```

---

## Phase 5 — Wire the Backend (new backend system)

Modern Backstage uses the **new backend system**. Your `packages/backend/src/index.ts`
should look like this after all plugin additions:

```ts
import { createBackend } from '@backstage/backend-defaults';

const backend = createBackend();

// Core
backend.add(import('@backstage/plugin-app-backend'));
backend.add(import('@backstage/plugin-catalog-backend'));
backend.add(import('@backstage/plugin-catalog-backend-module-scaffolder-entity-model'));
backend.add(import('@backstage/plugin-scaffolder-backend'));
backend.add(import('@backstage/plugin-scaffolder-backend-module-github'));
backend.add(import('@backstage/plugin-techdocs-backend'));
backend.add(import('@backstage/plugin-auth-backend'));
backend.add(import('@backstage/plugin-auth-backend-module-github-provider'));
backend.add(import('@backstage/plugin-search-backend'));
backend.add(import('@backstage/plugin-search-backend-module-catalog'));
backend.add(import('@backstage/plugin-search-backend-module-techdocs'));
backend.add(import('@backstage/plugin-proxy-backend'));

// Additional plugins
backend.add(import('@backstage/plugin-kubernetes-backend'));
backend.add(import('@backstage/plugin-sonarqube-backend'));
backend.add(import('@roadiehq/backstage-plugin-argo-cd-backend'));
backend.add(import('@pagerduty/backstage-plugin-backend'));
backend.add(import('@backstage/plugin-tech-insights-backend'));
backend.add(import('@backstage/plugin-tech-insights-backend-module-jsonfc'));

backend.start();
```

---

## Phase 6 — Set Environment Variables

Create `backstage-poc/.env` (add to `.gitignore`):

```bash
# Required
GITHUB_TOKEN=ghp_xxxxxxxxxxxxxxxxxxxx

# For GitHub login (optional)
GITHUB_CLIENT_ID=your_oauth_client_id
GITHUB_CLIENT_SECRET=your_oauth_client_secret

# For Kubernetes tab (optional — skip if no cluster)
K8S_CLUSTER_URL=https://your-cluster-api-server
K8S_SERVICE_ACCOUNT_TOKEN=your-sa-token
K8S_CA_DATA=base64-encoded-ca-cert

# For PagerDuty tab (optional)
PAGERDUTY_TOKEN=your-pagerduty-api-token

# For SonarQube tab (optional)
SONARQUBE_TOKEN=your-sonarqube-token

# For ArgoCD tab (optional)
ARGOCD_TOKEN=your-argocd-token
```

Load the env file when starting:

```bash
# Option A — use dotenv-cli
npx dotenv-cli -e .env -- yarn dev

# Option B — export manually
export $(cat .env | xargs) && yarn dev
```

---

## Phase 7 — Run the App

```bash
cd backstage-poc
yarn dev
```

- Frontend: http://localhost:3000
- Backend API: http://localhost:7007

---

## Phase 8 — Verify Each Feature

Work through this checklist after the app starts:

### Catalog
- [ ] Go to **Catalog** → you should see Components, APIs, Systems, etc.
- [ ] Filter by Kind: Domain, System, Component, API, Resource, Group, User
- [ ] Click `order-service` → check About, Relations graph, Links

### Relations Graph
- [ ] On any entity page → click **Relations** tab
- [ ] You should see the dependency graph (dependsOn, providesApis, etc.)

### API Explorer
- [ ] Go to **APIs** in the sidebar
- [ ] Click `orders-api` → should render the OpenAPI spec with Swagger UI
- [ ] Click `product-catalogue-api` → should render GraphQL schema
- [ ] Click `orders-events-asyncapi` → should render AsyncAPI spec

### TechDocs
- [ ] Click `order-service` → **Docs** tab
- [ ] Should render the MkDocs site with navigation (Architecture, API, Runbooks, ADRs)
- [ ] If blank: run `pip3 install mkdocs-techdocs-core` and restart

### Software Templates (Scaffolder)
- [ ] Go to **Create** in the sidebar
- [ ] You should see 4 templates: ECS Onboarding, Node.js Library, Documentation Site, Data Pipeline
- [ ] Click **ECS Onboarding** → walk through the 4-page wizard
- [ ] Check the dry-run output (no real AWS calls in POC mode)

### Org / People
- [ ] Go to **Settings** or search for a user (alice, bob, etc.)
- [ ] Click a Group (platform-team) → see members

### Tech Insights
- [ ] Go to **Tech Insights** in the sidebar (if plugin installed)
- [ ] Should show scorecard results for Production Readiness

### GitHub Actions tab
- [ ] Click any component with `github.com/project-slug` annotation
- [ ] **CI/CD** tab should show workflow runs (requires real repo)

---

## Troubleshooting

### Catalog entities not loading
- Check the GitHub token has `repo` and `read:org` scopes
- Verify the URLs in `catalog/all.yaml` match your actual GitHub org/repo
- Check backend logs: `yarn dev` output in terminal

### TechDocs not rendering
```bash
# Install the MkDocs plugin
pip3 install mkdocs-techdocs-core

# Verify Docker is running (needed for local generation)
docker ps
```

### Plugin tab not appearing
- Make sure you added both the `yarn add` AND the `EntityPage.tsx` code change
- Restart `yarn dev` after any package install

### "Not enough permissions" on catalog
- Add the entity kind to `catalog.rules` in `app-config.yaml`

### Template actions failing (aws:ecr:create, gocd:create-pipeline)
- These are custom actions — they won't run without the actual action implementations
- For POC demo purposes, replace them with `debug:log` to show the parameters:
  ```yaml
  - id: debug
    name: Show parameters
    action: debug:log
    input:
      message: "Would create ECS service: ${{ parameters.serviceName }}"
  ```

---

## Minimal POC (fastest path — 30 minutes)

If you just want to see the catalog, APIs, TechDocs, and templates without
installing every plugin:

1. Run `npx @backstage/create-app@latest`
2. Copy `backstage-config/app-config.yaml` → replace `app-config.yaml`
3. Update org/repo references
4. Set `GITHUB_TOKEN` env var
5. Run `yarn dev`

This gives you: Catalog, API Explorer, TechDocs, Scaffolder, Org graph — all
with zero extra plugin installs (they're built into the default app).

Add plugins one at a time from Phase 4 as needed.
