{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "clusterpedia.internal.storage.fullname" -}}
  {{- printf "%s-%s" (include "common.names.fullname" .) "internal-storage" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.job.internal.storage.pv.fullname" -}}
  {{- printf "check-%s-local-pv-dir" (include "clusterpedia.internal.storage.persistence.matchNode" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "clusterpedia.job.internal.storage.database.fullname" -}}
  {{- printf "check-%s-local-connection" (include "clusterpedia.internal.storage.type" .) -}}
{{- end -}}

{{- define "clusterpedia.internal.storage.user" -}}
  {{- if eq .Values.storageInstallMode "external" }}
   {{- required "Please set correct storage user!" .Values.externalStorage.user -}}
  {{- else }}
    {{- if eq (include "clusterpedia.internal.storage.type" .) "postgres" }}
      {{- if not (empty .Values.global.postgresql.auth.username) }}
        {{- .Values.global.postgresql.auth.username -}}
      {{- else }}
        {{- "postgres" -}}
      {{- end }}
    {{- else if eq (include "clusterpedia.internal.storage.type" .) "mysql" }}
      {{- if not (empty .Values.mysql.auth.username) }}
        {{ .Values.mysql.auth.username }}
      {{- else }}
        {{- "root" -}}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.internal.storage.password" -}}
  {{- if eq .Values.storageInstallMode "external" }}
     {{- required "Please set correct storage password!" .Values.externalStorage.password | b64enc -}}
  {{- else }}
    {{- if eq (include "clusterpedia.internal.storage.type" .) "postgres" }}
      {{- if not (empty .Values.global.postgresql.auth.username) }}
        {{- .Values.global.postgresql.auth.password | b64enc -}}
      {{- else }}
        {{- .Values.global.postgresql.auth.postgresPassword | b64enc -}}
      {{- end }}
    {{- else if eq (include "clusterpedia.internal.storage.type" .) "mysql" }}
      {{- if not (empty .Values.mysql.auth.username) }}
        {{- .Values.mysql.auth.password  | b64enc -}}
      {{- else }}
        {{- .Values.mysql.auth.rootPassword | b64enc -}}
      {{- end }}
     {{- end }}
  {{- end }}
{{- end -}}

{{/* use the default port */}}
{{- define "clusterpedia.internal.storage.port" -}}
  {{- if eq .Values.storageInstallMode "external" }}
    {{- required "Please set correct storage port!" .Values.externalStorage.port -}}
  {{- else }}
    {{- if eq (include "clusterpedia.internal.storage.type" .) "postgres" }}
      {{- .Values.postgresql.primary.service.ports.postgresql -}}
    {{- else if eq (include "clusterpedia.internal.storage.type" .) "mysql" }}
      {{- .Values.mysql.primary.service.ports.mysql -}}
    {{- end }}
  {{- end }}
{{- end -}}

{{/* use the default port */}}
{{- define "clusterpedia.internal.storage.host" -}}
  {{- if eq .Values.storageInstallMode "external" }}
    {{- required "Please set correct storage host!" .Values.externalStorage.host -}}
  {{- else }}
    {{- if eq (include "clusterpedia.internal.storage.type" .) "postgres" }}
      {{- include "clusterpedia.internal.storage.postgresql.fullname" . -}}
    {{- else if eq (include "clusterpedia.internal.storage.type" .) "mysql" }}
      {{- include "clusterpedia.internal.torage.mysql.fullname" . -}}
    {{- end }}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.internal.storage.database" -}}
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

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.internal.storage.postgresql.fullname" -}}
  {{- if .Values.postgresql.fullnameOverride }}
    {{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
  {{- else -}}
    {{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
    {{- if contains $name .Release.Name }}
      {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
    {{- else }}
      {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.internal.torage.mysql.fullname" -}}
  {{- if .Values.mysql.fullnameOverride }}
    {{- .Values.mysql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
  {{- else }}
    {{- $name := default "mysql" .Values.mysql.nameOverride -}}
    {{- if contains $name .Release.Name }}
      {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
    {{- else }}
      {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
    {{- end }}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.internal.storage.persistence.matchNode" -}}
  {{- if and (not (empty .Values.persistenceMatchNode)) (not (eq .Values.persistenceMatchNode "None")) }}
    {{- .Values.persistenceMatchNode -}}
  {{- else if not (eq .Values.persistenceMatchNode "None") }}
    {{- required "Please set parameter persistenceMatchNode, if PV resources are not required, set it to None!" .Values.persistenceMatchNode -}}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.internal.storage.internalstorage.capacity" }}
  {{- if eq (include "clusterpedia.internal.storage.type" .) "postgres" }}
    {{- .Values.postgresql.primary.persistence.size -}}
  {{- else if eq (include "clusterpedia.internal.storage.type" .) "mysql" }}
    {{- .Values.mysql.primary.persistence.size -}}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.internal.storage.type" -}}
  {{- if eq .Values.storageInstallMode "internal" }}
    {{- if or (and .Values.postgresql.enabled .Values.mysql.enabled) (and (not .Values.postgresql.enabled) (not .Values.mysql.enabled)) }}
      {{- required "Please enable the correct storage type!" "" -}}
    {{- else if .Values.postgresql.enabled }}
      {{- "postgres" -}}
    {{- else if .Values.mysql.enabled }}
      {{- "mysql" -}}
    {{- end }}
  {{- else }}
    {{- if or .Values.postgresql.enabled .Values.mysql.enabled -}}
      {{ required "Please also disable the internal mysql and postgres!" "" }}
    {{- else }}
      {{- required "A valid storage type is required!" .Values.externalStorage.type -}}
    {{- end }}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.internal.storage.database.image" -}}
  {{- if eq (include "clusterpedia.internal.storage.type" .) "postgres" }}
    {{- include "clusterpedia.internal.storage.postgresql.image" . -}}
  {{- else if eq (include "clusterpedia.internal.storage.type" .) "mysql" }}
    {{- include "clusterpedia.internal.storage.mysql.image" . -}}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.internal.storage.postgresql.image" -}}
  {{- include "common.images.image" (dict "imageRoot" .Values.postgresql.image "global" .Values.global) -}}
{{- end -}}

{{- define "clusterpedia.internal.storage.mysql.image" -}}
  {{- include "common.images.image" (dict "imageRoot" .Values.mysql.image "global" .Values.global) -}}
{{- end -}}

{{- define "clusterpedia.internal.storage.mountPath" -}}
  {{- if eq (include "clusterpedia.internal.storage.type" .) "postgres" }}
    {{- "/bitnami/postgresql" -}}
  {{- else if eq (include "clusterpedia.internal.storage.type" .) "mysql" }}
    {{- "/bitnami/mysql" -}}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.internal.storage.hostPath" -}}
 {{- printf "/var/local/clusterpedia/internalstorage/%s" (include "clusterpedia.internal.storage.type" .) -}}
{{- end -}}

{{- define "clusterpedia.internal.storage.lables" -}}
  {{- if eq (include "clusterpedia.internal.storage.type" .) "postgres" }}
    {{- .Values.postgresql.primary.persistence.selector.matchLables -}}
  {{- else if eq (include "clusterpedia.internal.storage.type" .) "mysql" }} 
    {{- .Values.mysql.primary.persistence.selector.matchLabels -}}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.storage.initContainer" -}}
- name: ensure-database
  image: {{ include "clusterpedia.initContainer.image" . }}
  command:
  - /bin/sh
  - -ec
  - |
    if [ ${CREARE_DATABASE} = "ture" ] && [ ${STORAGE_TYPE} = "postgres" ]; then
      until psql -U ${STORAGE_USER} -h ${STORAGE_HOST} -p ${STORAGE_PORT} postgres -c "SELECT 1 FROM pg_database WHERE datname = '${STORAGE_DATABASE}'" | grep -q 1 || psql -U ${STORAGE_USER} -h ${STORAGE_HOST} -p ${STORAGE_PORT} postgres -c "CREATE DATABASE ${STORAGE_DATABASE} owner ${STORAGE_USER} " -c "GRANT ALL PRIVILEGES ON DATABASE ${STORAGE_DATABASE} to ${STORAGE_USER}"; do 
      echo waiting for database check && sleep 1;
      done;
      echo 'DataBase OK ✓'
    elif [ ${CREARE_DATABASE} = "ture" ] && [ ${STORAGE_TYPE} = "mysql" ]; then
      until mysql -u${STORAGE_USER} -p${DB_PASSWORD} --host=${STORAGE_HOST} --port=${STORAGE_PORT} -e 'CREATE DATABASE IF NOT EXISTS ${STORAGE_DATABASE}'; do
      echo waiting for database check && sleep 1; 
      done;
      echo 'DataBase OK ✓'
    elif [ ${CREARE_DATABASE} = "false" ] && [ ${STORAGE_TYPE} = "postgres" ]; then
      until pg_isready -U ${STORAGE_USER} -d "dbname=${STORAGE_DATABASE}" -h ${STORAGE_HOST} -p ${STORAGE_PORT}; do sleep 1; done
    elif [ ${CREARE_DATABASE} = "false" ] && [ ${STORAGE_TYPE} = "mysql" ]; then
      until mysqladmin status -u${STORAGE_USER} -p${DB_PASSWORD} --host=${STORAGE_HOST} --port=${STORAGE_PORT}; do sleep 1; done
    fi
  env:
  - name: PGPASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ include "clusterpedia.storage.password" . }}
        key: password
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ include "clusterpedia.storage.password" . }}
        key: password
  envFrom: 
  - configMapRef:
      name: {{ include "clusterpedia.storage.initContainer.env" . }}
{{- end -}}

{{- define "clusterpedia.storage.env" -}}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "clusterpedia.storage.password" . }}
      key: password
{{- end -}}

{{- define "clusterpedia.storage.config" -}}
  {{- printf "%s-internal-storage-config" .Release.Name -}}
{{- end -}}

{{- define "clusterpedia.storage.initContainer.env" -}}
  {{- printf "%s-internal-storage-init-container-env" .Release.Name -}}
{{- end -}}

{{- define "clusterpedia.storage.password" -}}
  {{- printf "%s-internal-storage-password" .Release.Name -}}
{{- end -}}
