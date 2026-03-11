# Domain Layer

This chart manages domain-specific API/mock workloads and the shared domain routers.

## Scope

- Per-domain API Deployments/Services
- Per-domain mock Deployments/Services (or playground proxy mode)
- `api-router` for `/api-service/<domain>/<version>/...`
- `mock-router` for `/mock/<domain>/<version>/...`
- Shared env blocks via `commonEnv.api` and `commonEnv.mock`

## Deploy

```bash
helm upgrade --install automation-domain ./automation-infra/domain-layer \
  -f ./automation-infra/domain-layer/values.yaml \
  --namespace automation-dev
```

```bash
helm upgrade --install automation-domain ./automation-infra/domain-layer \
  -f ./automation-infra/domain-layer/values.yaml \
  -f ./automation-infra/domain-layer/values-preprod.yaml \
  --namespace automation-preprod
```

## Notes

- Domain and version are injected into each workload as `DOMAIN` and `DOMAIN_VERSION`.
- Mock routes support `mode: service` and `mode: playground`.
- Env merge order is: `commonEnv.<type>` -> `domains[].<type>.env` -> fixed keys (`DOMAIN`, `VERSION`, `DOMAIN_VERSION`).
