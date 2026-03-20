#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
helm_bin="${HELM_BIN:-helm}"
release_name="${RELEASE_NAME:-data-layer}"
namespace="${NAMESPACE:-automation-preprod}"

cmd=(
  "$helm_bin" upgrade "$release_name" "$script_dir"
  --namespace "$namespace"
  --install
  --reset-values
  --timeout 10m
  --debug
  -f "$script_dir/values-preprod.yaml"
)
cmd+=("$@")

printf 'Running:'
printf ' %q' "${cmd[@]}"
printf '\n'

"${cmd[@]}"
