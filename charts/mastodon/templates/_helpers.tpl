{{/*
Expand the name of the chart.
*/}}
{{- define "mastodon.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "mastodon.fullname" -}}
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
{{- define "mastodon.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mastodon.labels" -}}
helm.sh/chart: {{ include "mastodon.chart" . }}
{{ include "mastodon.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- if .Values.commonLabels }}
{{ .Values.commonLabels | toYaml }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "mastodon.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use FIXME
*/}}
{{- define "mastodon.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mastodon.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Mastodon database username and database name
*/}}
{{- define "mastodon.dbUsername" -}}
{{ (index .Values.postgrescluster.users 0).name }}
{{- end }}
{{- define "mastodon.dbName" }}
{{ (index (index .Values.postgrescluster.users 0).databases 0) }}
{{- end }}

{{/*
Name of the redis secret
*/}}
{{- define "mastodon.redisSecretName" -}}
{{- if .Values.redis.auth.existingSecret }}
{{- .Values.redis.auth.existingSecret }}
{{- else }}
{{- printf "%s-redis" (include "mastodon-standalone.fullname" .)}}
{{- end }}
{{- end }}

{{/*
Name of the redis instance; overrides the named template from mastodon-standalone, re-using the value that the redis subchart uses for its master service
FIXME this only works if we don't change the redis fullname in the metachart configuration, or if we update the mastodon-standalone.redis.host value accordingly
*/}}
{{- define "mastodon-standalone.redis.host" -}}
{{- printf "%s-redis-master" .Release.Name }}
{{- end }}

{{/*
Name of the postgres host; overrides the named template from mastodon-standalone, re-using the value that the postgres cluster subchart uses for the service
FIXME this only works if we don't change the cluster name in the metachart configuration, or if we update the mastodon-standalone.postgres.host value accordingly
*/}}
{{- define "mastodon-standalone.postgres.host" -}}
{{- default (printf "%s-primary" .Release.Name) .Values.postgres.host }}
{{- end }}

{{/*
secretKeyRef for postgres; overrides the named template from mastodon-standalone, re-using the value that the postgres cluster subchart uses for the secret
FIXME this only works if we don't change the cluster name or the username in the metachart configuration, or if we update the mastodon-standalone.postgres.secretKeyRef accordingly
*/}}
{{- define "mastodon-standalone.postgres.secretKeyRef" -}}
name: {{ default (printf "%s-pguser-mastodon" .Release.Name) .Values.postgres.secretKeyRef.name | quote }}
key: {{ default "password" .Values.postgres.secretKeyRef.key | quote }}
{{- end }}
