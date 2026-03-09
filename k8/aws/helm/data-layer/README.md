# Data Layer

This chart deploys stateful data services used by the automation service layer:

- Redis (`StatefulSet`)
- MongoDB (`StatefulSet`)

Both services expose:

- A stable client service (`redis`, `mongo`)
- A headless service for StatefulSet identity (`redis-headless`, `mongo-headless`)

## Install

```bash
helm upgrade --install data-layer ./data-layer --namespace automation-dev
```

## Notes

- Set `global.createNamespace=true` only if the namespace does not already exist.
- PVC size and storage class are configurable in `values.yaml`.
