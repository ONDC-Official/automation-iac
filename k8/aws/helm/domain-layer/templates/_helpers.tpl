{{/*
Expand the name of the chart.
*/}}
{{- define "automation-domain-layer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "automation-domain-layer.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "automation-domain-layer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "automation-domain-layer.labels" -}}
helm.sh/chart: {{ include "automation-domain-layer.chart" . }}
{{ include "automation-domain-layer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels.
*/}}
{{- define "automation-domain-layer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "automation-domain-layer.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Normalize domain/version values for k8s resource names.
*/}}
{{- define "automation-domain-layer.domainSlug" -}}
{{- . | lower | replace ":" "-" | replace "." "-" | replace "_" "-" | replace "/" "-" -}}
{{- end -}}

{{/*
Build a stable key from domain + version.
*/}}
{{- define "automation-domain-layer.domainKey" -}}
{{- $domain := include "automation-domain-layer.domainSlug" .domain -}}
{{- $version := include "automation-domain-layer.domainSlug" .version -}}
{{- printf "%s-v%s" $domain $version -}}
{{- end -}}

{{/*
Normalize arbitrary values for use in Kubernetes labels.
*/}}
{{- define "automation-domain-layer.labelValue" -}}
{{- $value := toString . -}}
{{- $normalized := regexReplaceAll "[^A-Za-z0-9._-]+" $value "-" -}}
{{- $normalized = regexReplaceAll "^[^A-Za-z0-9]+" $normalized "" -}}
{{- $normalized = regexReplaceAll "[^A-Za-z0-9]+$" $normalized "" -}}
{{- if not $normalized -}}
{{- $normalized = "na" -}}
{{- end -}}
{{- $normalized | trunc 63 | trimSuffix "-" | trimSuffix "." | trimSuffix "_" -}}
{{- end -}}

{{/*
Validate and normalize supported mock modes.
*/}}
{{- define "automation-domain-layer.mockMode" -}}
{{- $mode := default "service" . -}}
{{- if not (has $mode (list "service" "playground")) -}}
{{- fail (printf "mock.mode must be either \"service\" or \"playground\", got %q" $mode) -}}
{{- end -}}
{{- $mode -}}
{{- end -}}

{{/*
Resolve the shared playground upstream URL for a mock domain.
*/}}
{{- define "automation-domain-layer.playgroundUrl" -}}
{{- $root := index . "root" -}}
{{- $domain := index . "domain" -}}
{{- $playgroundUrl := coalesce (dig "mock" "playgroundUrl" "" $domain) $root.Values.mockRouter.defaultPlaygroundUrl -}}
{{- if not $playgroundUrl -}}
{{- fail (printf "domains[%s].mock.mode=playground requires mock.playgroundUrl or mockRouter.defaultPlaygroundUrl" (include "automation-domain-layer.domainKey" (dict "domain" $domain.domain "version" $domain.version))) -}}
{{- end -}}
{{- printf "%s/" (trimSuffix "/" $playgroundUrl) -}}
{{- end -}}
