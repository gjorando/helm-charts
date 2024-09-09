{{/*
Basic inline values
*/}}



{{/* GENERAL VALUES */}}

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



{{/* MANIFEST NAMES */}}

{{/*
Name of the service account.
*/}}
{{- define "mastodon-standalone.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "mastodon-standalone.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Name of the sidekiq deployment
*/}}
{{- define "mastodon-standalone.sidekiq.deploymentName" -}}
{{ printf "%s-sidekiq" (include "mastodon-standalone.fullname" .) }}
{{- end }}

{{/*
Name of the streaming deployment
*/}}
{{- define "mastodon-standalone.streaming.deploymentName" -}}
{{ printf "%s-streaming" (include "mastodon-standalone.fullname" .) }}
{{- end }}

{{/*
Name of the web deployment
*/}}
{{- define "mastodon-standalone.web.deploymentName" -}}
{{ printf "%s-web" (include "mastodon-standalone.fullname" .) }}
{{- end }}

{{/*
Name of the claim for the assets volume.
*/}}
{{- define "mastodon-standalone.persistence.assets.pvcName" -}}
{{- if .Values.persistence.existingClaims.assets }}
{{- .Values.persistence.existingClaims.assets }}
{{- else }}
{{- printf "%s-assets" (include "mastodon-standalone.fullname" .)}}
{{- end }}
{{- end }}

{{/*
Name of the claim for the system volume.
*/}}
{{- define "mastodon-standalone.persistence.system.pvcName" -}}
{{- if .Values.persistence.existingClaims.system }}
{{- .Values.persistence.existingClaims.system }}
{{- else }}
{{- printf "%s-system" (include "mastodon-standalone.fullname" .) }}
{{- end }}
{{- end }}

{{/*
Name of the job for precompiling assets.
*/}}
{{- define "mastodon-standalone.job.precompileAssetsName" -}}
{{- printf "%s-precompile-assets" (include "mastodon-standalone.fullname" .) }}
{{- end}}

{{/*
Name of the job for performing the database migrations.
*/}}
{{- define "mastodon-standalone.job.migrateDbName" -}}
{{- printf "%s-migrate-db" (include "mastodon-standalone.fullname" .) }}
{{- end}}

{{/*
Name of the job for generating the vapid key pair.
*/}}
{{- define "mastodon-standalone.job.generateVapidKeyName" -}}
{{- printf "%s-generate-vapid-key" (include "mastodon-standalone.fullname" .) }}
{{- end}}

{{/*
Name of the config map for the environment variables.
*/}}
{{- define "mastodon-standalone.env.configMapName" -}}
{{ printf "%s-env" (include "mastodon-standalone.fullname" .)}}
{{- end }}

{{/*
Name of the secret.
*/}}
{{- define "mastodon-standalone.env.secretName" -}}
{{- if .Values.existingSecret }}
{{- .Values.existingSecret }}
{{- else }}
{{- printf "%s-secret" (include "mastodon-standalone.fullname" .)}}
{{- end }}
{{- end }}



{{/* VARIOUS RESOURCE NAMES */}}

{{/*
Full image path with tag.
*/}}
{{- define "mastodon-standalone.image" -}}
{{- printf "%s:%s" .Values.image.repository (default .Chart.AppVersion .Values.image.tag) }}
{{- end }}

{{/*
Name of the redis host.
*/}}
{{- define "mastodon-standalone.redis.host" -}}
{{- required "Please provide the Redis instance hostname" .Values.redis.host }}
{{- end }}

{{/*
Name of the postgres host.
*/}}
{{- define "mastodon-standalone.postgres.host" -}}
{{- required "Please provide the database hostname" .Values.postgres.host }}
{{- end }}
