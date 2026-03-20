# Ingress Layer

This chart contains only ALB ingress routing for automation services.

## Scope

- Creates a single `Ingress` for automation routes.
- Joins the existing gcr ALB via `alb.ingress.kubernetes.io/group.name`.
- Supports stable domain routing entry points:
  - `/api-service/*` -> `api-router`
  - `/mock/*` -> `mock-router`
- Does not manage Deployments or Services.

## Deploy

```bash
helm upgrade --install automation-ingress ./automation-infra/ingress-layer \
  -f ./automation-infra/ingress-layer/values.yaml \
  --namespace automation-dev
```

```bash
helm upgrade --install automation-ingress ./automation-infra/ingress-layer \
  -f ./automation-infra/ingress-layer/values.yaml \
  -f ./automation-infra/ingress-layer/values-preprod.yaml \
  --namespace automation-preprod
```

## Notes

- Keep ALB-wide annotations in gcr ingress.
- Keep route-only annotations in this chart (`group.name`, `group.order`, host/path rules).
- Domain-router paths are controlled by `domainRouting` values.
- Router services are deployed by `automation-infra/domain-layer`.
