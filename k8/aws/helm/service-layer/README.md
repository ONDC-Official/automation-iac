# Service Layer

This chart is a boilerplate service layer for the deployable core services copied under `automation-infra/ONDC-automation-framework`.

## What is included

- Generic Service + Deployment rendering for the core workbench services
- Shared `playground-mock-service` workload for the central playground mock endpoint
- Optional namespace bootstrap inside this chart, disabled by default for shared namespaces
- Shared `commonEnv` values for envs reused across services
- Per-service env maps for service-specific settings

## What is excluded

- Per-domain API/mock workload definitions (moved to `automation-infra/domain-layer`)
- `monitoring` (belongs in observability, not service-layer)
- `form_service_staging`
- Folders without a clear top-level runtime definition (`finvu-aa-service-main`, `gtfs-vis`)

## Notes

- Repeated env values are centralized in `commonEnv`.
- Internal service-to-service URLs are prefilled with the renamed in-cluster service names.
- `commonEnv.playgroundMockServiceUrl` resolves to the in-cluster `playground-mock-service` and is reused by UI, backoffice, form-service, and shared playground routing.
- Service-specific env keys stay inside each service block.
