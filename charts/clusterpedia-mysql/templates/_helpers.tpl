{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.mysql.storage.fullname" -}}
  {{- if contains "mysql" .Release.Name }}
    {{- printf "%s-%s" .Release.Name "storage" | trunc 63 | trimSuffix "-" -}}
  {{- else }}
    {{- printf "%s-%s-%s" .Release.Name "mysql" "storage" | trunc 63 | trimSuffix "-" -}}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.job.mysql.storage.pv.fullname" -}}
  {{- printf "check-%s-local-pv-dir" (include "clusterpedia.mysql.storage.persistence.matchNode" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "clusterpedia.mysql.storage.initContainer.env.name" -}}
  {{- printf "%s-mysql-storage-initcontainer-env" .Release.Name -}}
{{- end -}}

{{- define "clusterpedia.mysql.storage.image" -}}
  {{- include "common.images.image" (dict "imageRoot" .Values.mysql.image "global" .Values.global) -}}
{{- end -}}

{{- define "clusterpedia.mysql.storage.user" -}}
  {{- if eq .Values.storageInstallMode "external" }}
    {{- required "Please set correct storage user!" .Values.externalStorage.user -}}
  {{- else if not (empty .Values.mysql.auth.username) }}
    {{- .Values.mysql.auth.username -}}
  {{- else }}
    {{- "root" -}}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.mysql.storage.password" -}}
  {{- if eq .Values.storageInstallMode "external" }}
    {{- required "Please set correct storage password!" .Values.externalStorage.password | b64enc -}}
  {{- else if not (empty .Values.mysql.auth.username) }}
    {{- .Values.mysql.auth.password  | b64enc -}}
  {{- else }}
    {{- .Values.mysql.auth.rootPassword | b64enc -}}
  {{- end }}
{{- end -}}

{{/* use the default port */}}
{{- define "clusterpedia.mysql.storage.port" -}}
  {{- if eq .Values.storageInstallMode "external" }}
    {{- required "Please set correct storage port!" .Values.externalStorage.port -}}
  {{- else }}
    {{- .Values.mysql.primary.service.ports.mysql -}}
  {{- end }}
{{- end -}}

{{/* use the default port */}}
{{- define "clusterpedia.mysql.storage.host" -}}
  {{- if eq .Values.storageInstallMode "external" }}
    {{- required "Please set correct storage host!" .Values.externalStorage.host -}}
  {{- else }}
    {{- "clusterpedia-mysql" -}}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.mysql.storage.database" -}}
  {{- if eq .Values.storageInstallMode "external" }}
    {{- if empty .Values.externalStorage.database }}
      {{- required "Please set correct storage database!" "" -}}
    {{- else }}
      {{- .Values.externalStorage.database -}}
    {{- end }}
  {{- else }}
    {{- "clusterpedia" -}}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.mysql.storage.persistence.matchNode" -}}
  {{- if and (not (empty .Values.persistenceMatchNode)) (not (eq .Values.persistenceMatchNode "None")) }}
    {{- .Values.persistenceMatchNode -}}
  {{- else if not (eq .Values.persistenceMatchNode "None") }}
    {{- required "Please set parameter persistenceMatchNode, if PV resources are not required, set it to None!" .Values.persistenceMatchNode -}}
  {{- end }}
{{- end -}}
