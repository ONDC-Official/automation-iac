# Service Layer

This chart is a boilerplate service layer for the deployable core services copied under `automation-infra/ONDC-automation-framework`.

## What is included

- Generic Service + Deployment rendering for the core workbench services
- Optional namespace bootstrap inside this chart
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
- Service-specific env keys stay inside each service block.
