{{/*
Expand the name of the chart.
*/}}
{{- define "mastodon-standalone.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mastodon-standalone.fullname" -}}
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
Create chart name and version as used by the chart label.
*/}}
{{- define "mastodon-standalone.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels applied to every object
*/}}
{{- define "mastodon-standalone.commonLabels" -}}
{{- if .Values.commonLabels }}
{{ .Values.commonLabels | toYaml }}
{{- end }}
{{- end }}

{{/*
Common labels, including selector labels, version identifier and helm related labels
*/}}
{{- define "mastodon-standalone.labels" -}}
helm.sh/chart: {{ include "mastodon-standalone.chart" . }}
{{ include "mastodon-standalone.selectorLabels" . }}
{{- include "mastodon-standalone.commonLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mastodon-standalone.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon-standalone.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "mastodon-standalone.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mastodon-standalone.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Rolling pod annotations
*/}}
{{- define "mastodon-standalone.rollingPodAnnotations" -}}
rollme: {{ randAlphaNum 5 | quote }}
{{- /* TODO add secrets checksums here, and add to the common pod labels of mastodon megachart the checksums for the redis secrets
checksum/config-secrets: {{ include ( print $.Template.BasePath "/secrets.yaml" ) . | sha256sum | quote }}
*/}}
{{- end }}

{{/*
Full image path with tag
*/}}
{{- define "mastodon-standalone.image" -}}
{{- printf "%s:%s" .Values.image.repository (default .Chart.AppVersion .Values.image.tag) }}
{{- end }}

{{/*
Data volumes
*/}}
{{- define "mastodon-standalone.dataVolumes" -}}
- name: "assets"
  {{- if .Values.persistence.enabled }}
  persistentVolumeClaim:
  claimName: {{ include "mastodon-standalone.pvc.assets" . | quote }}
  {{- else }}
  emptyDir: {}
  {{- end }}
- name: "system"
  {{- if .Values.persistence.enabled }}
  persistentVolumeClaim:
  claimName: {{ include "mastodon-standalone.pvc.system" . | quote }}
  {{- else }}
  emptyDir: {}
  {{- end }}
{{- end }}

{{/*
Data volume mounts
*/}}
{{- define "mastodon-standalone.dataVolumeMounts" -}}
- name: assets
  mountPath: /opt/mastodon/public/assets
- name: system
  mountPath: /opt/mastodon/public/system
{{- end }}

{{/*
Names for each persistent volume claim
*/}}

{{- define "mastodon-standalone.pvc.assets" -}}
{{- if .Values.persistence.existingClaims.assets }}
{{- .Values.persistence.existingClaims.assets }}
{{- else }}
{{- printf "%s-assets-volume" (include "mastodon-standalone.fullname" .)}}
{{- end }}
{{- end }}

{{- define "mastodon-standalone.pvc.system" -}}
{{- if .Values.persistence.existingClaims.system }}
{{- .Values.persistence.existingClaims.system }}
{{- else }}
{{- printf "%s-system-volume" (include "mastodon-standalone.fullname" .) }}
{{- end }}
{{- end }}
