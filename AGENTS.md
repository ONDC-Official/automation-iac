# Repository Guidelines

## Project Structure & Module Organization
This repository is primarily Helm-based infrastructure. Core charts live under `k8/aws/helm/`:

- `service-layer/` for shared application services
- `domain-layer/` for domain-specific API and mock workloads
- `data-layer/` for Redis and MongoDB stateful services
- `ingress-layer/` for ALB ingress routing

Each chart keeps `Chart.yaml`, `values.yaml`, optional `values-preprod.yaml`, and a `templates/` directory. CI/CD workflows live in `.github/workflows/`. A root `docker-compose.yml` exists for local Postgres only.

## Domain-Layer Findings
`k8/aws/helm/domain-layer/` is the chart we will be touching most. The committed base and preprod values both currently ship with `domains: []`, so domain work usually means adding or editing entries in that list rather than changing shared defaults. A valid domain entry is driven by `domain`, `version`, and nested `api` and/or `mock` blocks; `enabled` defaults to `true`.

Resource names are generated from a normalized key built from domain plus version. The helper lowercases values and replaces `:`, `.`, `_`, and `/` with `-`, so `ONDC:FIS13` + `2.0.0` becomes `domain-ondc-fis13-v2-0-0-api` or `...-mock` unless `serviceName` is overridden. Keep that normalization in mind when reviewing rendered service names, labels, and routes.

The chart always treats routers separately from per-domain workloads. `api-router` and `mock-router` are NGINX deployments plus configmaps; when no matching domain route exists they return `404`. `mock.mode: playground` skips rendering a mock service/deployment and proxies `/mock/<domain>/<version>/...` to `mockRouter.defaultPlaygroundUrl` or a per-domain `playgroundUrl`. In `service` mode, both API and mock routes can override the default upstream with `route.upstreamService`, `route.upstreamPort`, `route.upstreamScheme`, and `route.upstreamBasePath`.

Environment variables are merged in a strict order: `commonEnv.api|mock` -> per-domain `api.env|mock.env` -> fixed keys `DOMAIN`, `VERSION`, `DOMAIN_VERSION`. `global.createNamespace` controls optional namespace creation. One repo quirk: the chart README still shows deploy commands under `./automation-infra/domain-layer`; use the real repo path `k8/aws/helm/domain-layer` instead.

## Build, Test, and Development Commands
Use Helm validation before opening a PR:

- `helm lint k8/aws/helm/service-layer` checks chart structure and template syntax.
- `helm lint k8/aws/helm/domain-layer` checks the chart we are actively changing.
- `helm template automation-domain k8/aws/helm/domain-layer -f k8/aws/helm/domain-layer/values.yaml` renders base domain manifests locally.
- `helm template automation-domain k8/aws/helm/domain-layer -f k8/aws/helm/domain-layer/values.yaml -f k8/aws/helm/domain-layer/values-preprod.yaml` validates preprod overlay merges.
- `helm template automation-ingress k8/aws/helm/ingress-layer -f k8/aws/helm/ingress-layer/values.yaml -f k8/aws/helm/ingress-layer/values-preprod.yaml` validates overlay merges.
- `docker compose up -d postgres` starts the local Postgres container defined in `docker-compose.yml`.

## Coding Style & Naming Conventions
Use two-space indentation in YAML and preserve Helm template whitespace controls such as `{{- ... }}`. Keep template filenames lowercase and hyphenated, for example `config-service.yaml` or `domain-mock-router.yaml`. Prefer camelCase for values keys (`commonEnv`, `createNamespace`) and uppercase snake case for rendered environment variables (`TRACE_URL`, `REDIS_PORT`). Add new environment-specific overrides to `values-preprod.yaml` instead of duplicating full base files.

## Testing Guidelines
There is no dedicated unit-test suite in this repository. Treat `helm lint` and `helm template` as the required validation baseline for every changed chart. When editing routing or environment maps, render both default and preprod values and review the generated service names, ports, hosts, and namespaces.

## Commit & Pull Request Guidelines
Recent history uses short, imperative commits with optional prefixes such as `feat:`, `ci:`, and scoped forms like `ci(config-service): ...`. Follow that pattern and keep each commit focused on one chart or workflow. PRs should state the affected chart or workflow, target environment (`dev` or `preprod`), any changed image tags, hosts, or paths, and the validation commands you ran. Include rendered manifest excerpts when ingress rules or domain routing change.

## Security & Configuration Tips
Do not commit secrets, tokens, or filled `.env` files. Keep sensitive values in GitHub Actions secrets or deployment-time overrides, and leave placeholders such as `REPLACE_ME` in committed values files.
