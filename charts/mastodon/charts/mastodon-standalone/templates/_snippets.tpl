{{/*
Multiline snippets
*/}}



{{/* LABELS */}}

{{/*
Common labels, including selector labels, version identifier and helm related labels.
*/}}
{{- define "mastodon-standalone.labels" -}}
helm.sh/chart: {{ include "mastodon-standalone.chart" . | quote }}
{{ include "mastodon-standalone.selectorLabels" . }}
{{- include "mastodon-standalone.commonLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service | quote }}
{{- end }}

{{/*
Common labels applied to every object.
*/}}
{{- define "mastodon-standalone.commonLabels" -}}
{{- if .Values.commonLabels }}
{{- .Values.commonLabels | toYaml }}
{{- end }}
{{- end }}

{{/*
Selector labels.
*/}}
{{- define "mastodon-standalone.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mastodon-standalone.name" . | quote }}
app.kubernetes.io/instance: {{ .Release.Name | quote }}
{{- end }}

{{- define "mastodon-standalone.sidekiq.labels" -}}
app.kubernetes.io/component: sidekiq
app.kubernetes.io/part-of: rails
{{- end }}

{{- define "mastodon-standalone.streaming.labels" -}}
app.kubernetes.io/component: streaming
app.kubernetes.io/part-of: node
{{- end }}

{{- define "mastodon-standalone.web.labels" -}}
app.kubernetes.io/component: web
app.kubernetes.io/part-of: rails
{{- end }}



{{/* ANNOTATIONS */}}

{{/*
Rolling pod annotations.
*/}}
{{- define "mastodon-standalone.rollingPodAnnotations" -}}
rollme: {{ randAlphaNum 5 | quote }}
{{- /* TODO add secrets checksums here, and add to the common pod labels of mastodon megachart the checksums for the redis secrets
checksum/config-secrets: {{ include ( print $.Template.BasePath "/secrets.yaml" ) . | sha256sum | quote }}
*/}}
{{- end }}



{{/* VOLUMES AND MOUNTS  */}}

{{/*
Data volumes.
*/}}
{{- define "mastodon-standalone.persistence.volumes" -}}
- name: "assets"
  {{- if .Values.persistence.enabled }}
  persistentVolumeClaim:
    claimName: {{ include "mastodon-standalone.persistence.assets.pvcName" . | quote }}
  {{- else }}
  emptyDir: {}
  {{- end }}
- name: "system"
  {{- if .Values.persistence.enabled }}
  persistentVolumeClaim:
    claimName: {{ include "mastodon-standalone.persistence.system.pvcName" . | quote }}
  {{- else }}
  emptyDir: {}
  {{- end }}
{{- end }}

{{/*
Data volume mounts.
*/}}
{{- define "mastodon-standalone.persistence.volumeMounts" -}}
- name: assets
  mountPath: /opt/mastodon/public/assets
- name: system
  mountPath: /opt/mastodon/public/system
{{- end }}



{{/* ENVIRONMENT VALUES */}}

{{/*
Environment values for the deployed containers.
*/}}
{{- define "mastodon-standalone.env.snippet" -}}
envFrom:
- configMapRef:
    name: {{ include "mastodon-standalone.env.configMapName" . | quote }}
- secretRef:
    name: {{ include "mastodon-standalone.env.secretName" . | quote }}
env: 
{{- if .Values.redis.secretKeyRef }}
- name: "REDIS_PASSWORD"
  valueFrom:
    secretKeyRef:
      {{- toYaml .Values.redis.secretKeyRef | nindent 6 }}
{{- end }}
{{- if .Values.postgres.secretKeyRef }}
- name: "DB_PASS"
  valueFrom:
    secretKeyRef:
      {{- include "mastodon-standalone.postgres.secretKeyRef" . | nindent 6 }}
{{- end }}
{{- if .Values.smtp.enabled }}
- name: "SMTP_PASSWORD"
  valueFrom:
    secretKeyRef:
      {{- toYaml (required "Please provide a secret key reference for the SMTP password" .Values.smtp.secretKeyRef) | nindent 6 }}
{{- end }}
{{- end }}

{{/*
secretKeyRef for postgres.
*/}}
{{- define "mastodon-standalone.postgres.secretKeyRef" -}}
{{- with .Values.postgres.secretKeyRef }}
{{- toYaml . }}
{{- end }}
{{- end }}

