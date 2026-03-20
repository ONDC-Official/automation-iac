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
helm upgrade --install automation-domain k8/aws/helm/domain-layer \
  -f k8/aws/helm/domain-layer/values.yaml \
  --namespace automation-dev
```

```bash
helm upgrade --install automation-domain k8/aws/helm/domain-layer \
  -f k8/aws/helm/domain-layer/values.yaml \
  -f k8/aws/helm/domain-layer/values-preprod.yaml \
  --namespace automation-preprod
```

## Notes

- Domain and version are injected into each workload as `DOMAIN` and `DOMAIN_VERSION`.
- Mock routes support `mode: service` and `mode: playground`.
- `mock.mode: playground` reuses `mockRouter.defaultPlaygroundUrl` unless a domain sets `mock.playgroundUrl`; the default now points at the shared in-cluster `playground-mock-service`.
- Playground domains create only router entries; dedicated mock Deployments/Services are rendered only for `mock.mode: service`.
- Every enabled domain with `mock.enabled != false` generates its own `/mock/<domain>/<version>/...` route automatically.
- Env merge order is: `commonEnv.<type>` -> `domains[].<type>.env` -> fixed keys (`DOMAIN`, `VERSION`, `DOMAIN_VERSION`).
