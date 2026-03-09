{{/*
Expand the name of the chart.
*/}}
{{- define "automation-service-layer.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "automation-service-layer.fullname" -}}
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
{{- define "automation-service-layer.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "automation-service-layer.labels" -}}
helm.sh/chart: {{ include "automation-service-layer.chart" . }}
{{ include "automation-service-layer.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Selector labels.
*/}}
{{- define "automation-service-layer.selectorLabels" -}}
app.kubernetes.io/name: {{ include "automation-service-layer.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Render a service and deployment from a generic service config.
*/}}
{{- define "automation-service-layer.renderService" -}}
{{- $root := .root -}}
{{- $service := .service -}}
{{- $name := .name -}}
{{- $component := .component -}}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ $name }}
  namespace: {{ $root.Values.global.namespace | default $root.Release.Namespace }}
  labels:
    app: {{ $name }}
    {{- include "automation-service-layer.labels" $root | nindent 4 }}
spec:
  type: {{ $service.service.type }}
  selector:
    app: {{ $name }}
  ports:
    - name: http
      port: {{ $service.service.port }}
      targetPort: {{ $service.service.port }}
    {{- if $service.service.grpcPort }}
    - name: grpc
      port: {{ $service.service.grpcPort }}
      targetPort: {{ $service.service.grpcPort }}
    {{- end }}

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ $name }}
  namespace: {{ $root.Values.global.namespace | default $root.Release.Namespace }}
  labels:
    app: {{ $name }}
    {{- include "automation-service-layer.labels" $root | nindent 4 }}
spec:
  replicas: {{ $root.Values.global.replicas }}
  selector:
    matchLabels:
      app: {{ $name }}
  template:
    metadata:
      labels:
        app: {{ $name }}
        component: {{ $component }}
    spec:
      containers:
        - name: {{ $name }}
          image: {{ $service.image.repository }}:{{ $service.image.tag }}
          imagePullPolicy: {{ $root.Values.global.imagePullPolicy }}
          {{- with $service.command }}
          command:
{{ toYaml . | nindent 12 }}
          {{- end }}
          ports:
            - name: http
              containerPort: {{ $service.service.port }}
            {{- if $service.service.grpcPort }}
            - name: grpc
              containerPort: {{ $service.service.grpcPort }}
            {{- end }}
          {{- with $service.env }}
          env:
            {{- range $envName, $envValue := . }}
            - name: {{ $envName }}
              value: {{ tpl (toString $envValue) $root | quote }}
            {{- end }}
          {{- end }}
          resources:
{{ toYaml $root.Values.global.resources | nindent 12 }}
{{- end -}}
