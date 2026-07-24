{{/*
Expand the name of the chart.
*/}}
{{- define "schema-rag.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "schema-rag.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Chart label — injected into every resource.
*/}}
{{- define "schema-rag.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version }}
{{- end }}

{{/*
Common labels.
*/}}
{{- define "schema-rag.labels" -}}
helm.sh/chart: {{ include "schema-rag.chart" . }}
{{ include "schema-rag.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "schema-rag.selectorLabels" -}}
app.kubernetes.io/name: {{ include "schema-rag.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Component labels — for sub-components (mysql, qdrant, ollama).
Usage: include "schema-rag.componentLabels" (list . "mysql")
*/}}
{{- define "schema-rag.componentLabels" -}}
{{- $root := index . 0 }}
{{- $component := index . 1 }}
app.kubernetes.io/name: {{ include "schema-rag.name" $root }}-{{ $component }}
app.kubernetes.io/instance: {{ $root.Release.Name }}
app.kubernetes.io/component: {{ $component }}
helm.sh/chart: {{ include "schema-rag.chart" $root }}
app.kubernetes.io/version: {{ $root.Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ $root.Release.Service }}
{{- end }}
