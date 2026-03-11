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
