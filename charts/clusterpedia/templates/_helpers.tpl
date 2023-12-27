{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}

{{- define "clusterpedia.apiserver.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "apiserver" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.clustersynchroManager.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "clustersynchro-manager" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.controllerManager.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "controller-manager" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.kubeStateMetrics.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "kube-state-metrics" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper apiserver image name
*/}}
{{- define "clusterpedia.apiserver.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.apiserver.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper clustersynchroManager image name
*/}}
{{- define "clusterpedia.clustersynchroManager.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.clustersynchroManager.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper controllerManager image name
*/}}
{{- define "clusterpedia.controllerManager.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.controllerManager.image "global" .Values.global) }}
{{- end -}}

{{- define "clusterpedia.internalstorage.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "internalstorage" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "clusterpedia.scripts.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) "scripts" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "clusterpedia.apiserver.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.apiserver.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "clusterpedia.clustersynchroManager.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.clustersynchroManager.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "clusterpedia.controllerManager.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.controllerManager.image) "global" .Values.global) }}
{{- end -}}

{{- define "clusterpedia.apiserver.featureGates" -}}
     {{- if (not (empty .Values.apiserver.featureGates)) }}
          {{- $featureGatesFlag := "" -}}
          {{- range $key, $value := .Values.apiserver.featureGates -}}
               {{- if not (empty (toString $value)) }}
                    {{- $featureGatesFlag = cat $featureGatesFlag $key "=" $value "," -}}
               {{- end -}}
          {{- end -}}

          {{- if gt (len $featureGatesFlag) 0 }}
               {{- $featureGatesFlag := trimSuffix "," $featureGatesFlag  | nospace -}}
               {{- printf "%s=%s" "--feature-gates" $featureGatesFlag -}}
          {{- end -}}
     {{- end -}}
{{- end -}}

{{- define "clusterpedia.clustersynchroManager.featureGates" -}}
     {{- if (not (empty .Values.clustersynchroManager.featureGates)) }}
          {{- $featureGatesFlag := "" -}}
          {{- range $key, $value := .Values.clustersynchroManager.featureGates -}}
               {{- if not (empty (toString $value)) }}
                    {{- $featureGatesFlag = cat $featureGatesFlag $key "=" $value ","  -}}
               {{- end -}}
          {{- end -}}

          {{- if gt (len $featureGatesFlag) 0 }}
               {{- $featureGatesFlag := trimSuffix "," $featureGatesFlag  | nospace -}}
               {{- printf "%s=%s" "--feature-gates" $featureGatesFlag -}}
          {{- end -}}
     {{- end -}}
{{- end -}}

{{- define "clusterpedia.controllerManager.featureGates" -}}
     {{- if (not (empty .Values.controllerManager.featureGates)) }}
          {{- $featureGatesFlag := "" -}}
          {{- range $key, $value := .Values.controllerManager.featureGates -}}
               {{- if not (empty (toString $value)) }}
                    {{- $featureGatesFlag = cat $featureGatesFlag $key "=" $value ","  -}}
               {{- end -}}
          {{- end -}}

          {{- if gt (len $featureGatesFlag) 0 }}
               {{- $featureGatesFlag := trimSuffix "," $featureGatesFlag  | nospace -}}
               {{- printf "%s=%s" "--feature-gates" $featureGatesFlag -}}
          {{- end -}}
     {{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.dsn" -}}
{{- if eq .Values.storageInstallMode "external" }}
{{- if not (empty .Values.externalStorage.dsn) -}}
     {{- if eq .Values.externalStorage.type "mysql" }}
         {{- .Values.externalStorage.dsn }}
     {{- else if eq (include "clusterpedia.storage.type" .) "postgres" -}}
         {{- .Values.externalStorage.dsn }}
     {{- else -}}
         {{ required "storage dsn only supports mysql or postgres" "" }}
     {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "clusterpedia.storage.user" -}}
{{- if eq .Values.storageInstallMode "external" }}
     {{- if empty (include "clusterpedia.storage.dsn" .) -}}
         {{- required "Please set correct storage user!" .Values.externalStorage.user -}}
     {{- else -}}
         {{- .Values.externalStorage.user -}}
     {{- end -}}
{{- else -}}
     {{- if eq (include "clusterpedia.storage.type" .) "postgres" -}}
          {{- if not (empty .Values.global.postgresql.auth.username) -}}
               {{- .Values.global.postgresql.auth.username -}}
          {{- else -}}
               {{- "postgres" -}}
          {{- end -}}
     {{- else if eq (include "clusterpedia.storage.type" .) "mysql" -}}
          {{- if not (empty .Values.mysql.auth.username) -}}
               {{- .Values.mysql.auth.username -}}
          {{- else -}}
               {{- "root" -}}
          {{- end -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.password" -}}
{{- if eq .Values.storageInstallMode "external" }}
     {{- if empty (include "clusterpedia.storage.dsn" .) -}}
         {{- required "Please set correct storage password!" .Values.externalStorage.password | toString | b64enc -}}
     {{- else -}}
         {{- .Values.externalStorage.password | toString | b64enc -}}
     {{- end -}}
{{- else -}}
     {{- if eq (include "clusterpedia.storage.type" .) "postgres" }}
          {{- if not (empty .Values.global.postgresql.auth.username) -}}
               {{- .Values.global.postgresql.auth.password | toString | b64enc -}}
          {{- else -}}
               {{- .Values.global.postgresql.auth.postgresPassword | toString | b64enc -}}
          {{- end -}}
     {{- else if eq (include "clusterpedia.storage.type" .) "mysql" -}}
          {{- if not (empty .Values.mysql.auth.username) -}}
               {{- .Values.mysql.auth.password | toString | b64enc -}}
          {{- else -}}
               {{- .Values.mysql.auth.rootPassword | toString | b64enc -}}
          {{- end -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/* use the default port */}}
{{- define "clusterpedia.storage.port" -}}
{{- if eq .Values.storageInstallMode "external" }}
     {{- if empty (include "clusterpedia.storage.dsn" .) -}}
         {{- required "Please set correct storage port!" .Values.externalStorage.port -}}
     {{- else -}}
         {{- .Values.externalStorage.port }}
     {{- end -}}
{{- else -}}
     {{- if eq (include "clusterpedia.storage.type" .) "postgres" -}}
     {{- .Values.postgresql.primary.service.ports.postgresql -}}
          {{- else if eq (include "clusterpedia.storage.type" .) "mysql" -}}
     {{- .Values.mysql.primary.service.ports.mysql -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/* use the default port */}}
{{- define "clusterpedia.storage.host" -}}
{{- if eq .Values.storageInstallMode "external" }}
     {{- if empty (include "clusterpedia.storage.dsn" .) -}}
         {{- required "Please set correct storage host!" .Values.externalStorage.host -}}
     {{- else -}}
         {{- .Values.externalStorage.host }}
     {{- end -}}
{{- else -}}
     {{- if eq (include "clusterpedia.storage.type" .) "postgres" -}}
          {{- include "clusterpedia.postgresql.fullname" . -}}
     {{- else if eq (include "clusterpedia.storage.type" .) "mysql" -}}
          {{- include "clusterpedia.mysql.fullname" . -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.database" -}}
{{- if eq .Values.storageInstallMode "external" }}
     {{- if empty (include "clusterpedia.storage.dsn" .) -}}
          {{- required "Please set correct storage database!" .Values.externalStorage.database -}}
     {{- else -}}
          {{- .Values.externalStorage.database -}}
     {{- end -}}
{{- else -}}
     {{- "clusterpedia" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.postgresql.fullname" -}}
{{- if .Values.postgresql.fullnameOverride -}}
     {{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
     {{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
     {{- if contains $name .Release.Name -}}
          {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
     {{- else -}}
          {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.mysql.fullname" -}}
{{- if .Values.mysql.fullnameOverride -}}
     {{- .Values.mysql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
     {{- $name := default "mysql" .Values.mysql.nameOverride -}}
     {{- if contains $name .Release.Name -}}
          {{- .Release.Name | trunc 63 | trimSuffix "-" -}}
     {{- else -}}
          {{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "clusterpedia.job.storage.fullname" -}}
{{- printf "check-%s-local-pv-dir" (include "clusterpedia.persistence.matchNode" .) -}}
{{- end -}}

{{- define "clusterpedia.persistence.matchNode" -}}
{{- if and (not (empty .Values.persistenceMatchNode)) (not (eq .Values.persistenceMatchNode "None")) }}
     {{- .Values.persistenceMatchNode -}}
{{- else if not (eq .Values.persistenceMatchNode "None") -}}
     {{- required "Please set parameter persistenceMatchNode, if PV resources are not required, set it to None!" .Values.persistenceMatchNode -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.internalstorage.capacity" -}}
{{- if eq (include "clusterpedia.storage.type" .) "postgres" -}}
     {{- .Values.postgresql.primary.persistence.size -}}
{{- else if eq (include "clusterpedia.storage.type" .) "mysql" -}}
     {{- .Values.mysql.primary.persistence.size -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.type" -}}
{{- if eq .Values.storageInstallMode "internal" }}
     {{- if or (and .Values.postgresql.enabled .Values.mysql.enabled) (and (not .Values.postgresql.enabled) (not .Values.mysql.enabled)) }}
          {{ required "Please enable the correct storage type!" "" }}
     {{- else if .Values.postgresql.enabled }}
         {{- "postgres" -}}
     {{- else if .Values.mysql.enabled }}
          {{- "mysql" -}}
     {{- end -}}
{{- else -}}
     {{- if or .Values.postgresql.enabled .Values.mysql.enabled -}}
          {{ required "Please also disable the internal mysql and postgres!" "" }}
     {{- else -}}
          {{- required "A valid storage type is required!" .Values.externalStorage.type -}}
     {{- end -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.image" -}}
{{- if eq (include "clusterpedia.storage.type" .) "postgres" -}}
     {{- include "clusterpedia.storage.postgresql.image" . -}}
{{- else if eq (include "clusterpedia.storage.type" .) "mysql" -}}
     {{- include "clusterpedia.storage.mysql.image" . -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.postgresql.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.postgresql.image "global" .Values.global) }}
{{- end -}}

{{- define "clusterpedia.storage.mysql.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.mysql.image "global" .Values.global) }}
{{- end -}}

{{- define "clusterpedia.storage.mountPath" -}}
{{- if eq (include "clusterpedia.storage.type" .) "postgres" -}}
     {{- "/bitnami/postgresql" -}}
{{- else if eq (include "clusterpedia.storage.type" .) "mysql" -}}
     {{- "/bitnami/mysql" -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.hostPath" -}}
{{- printf "/var/local/clusterpedia/internalstorage/%s" (include "clusterpedia.storage.type" .) -}}
{{- end -}}

{{- define "clusterpedia.storage.lables" -}}
{{- if eq (include "clusterpedia.storage.type" .) "postgres" }}
     {{- .Values.postgresql.primary.persistence.selector.matchLables -}}
{{- else if eq (include "clusterpedia.storage.type" .) "mysql" -}}
     {{- .Values.mysql.primary.persistence.selector.matchLabels -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.storage.password.envKey" -}}
{{- if eq (include "clusterpedia.storage.type" .) "postgres" }}
     {{- "PGPASSWORD" -}}
{{- else if eq (include "clusterpedia.storage.type" .) "mysql" -}}
     {{- "DB_PASSWORD" -}}
{{- end -}}
{{- end -}}

{{- define "clusterpedia.hookJob.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.hookJob.image "global" .Values.global) }}
{{- end -}}

{{- define "clusterpedia.apiserver.tracing.env" -}}
{{- if .Values.apiserver.telemetry.tracing.addOtelEnv }}
{{- if not (empty .Values.apiserver.telemetry.tracing.endpoint) }}
- name: OTEL_EXPORTER_OTLP_ENDPOINT
  value: {{ .Values.apiserver.telemetry.tracing.endpoint }}
{{- end }}
- name: OTEL_SERVICE_NAME
  value: {{ include "common.names.fullname" . }}-apiserver
- name: OTEL_K8S_NAMESPACE
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: metadata.namespace
- name: OTEL_RESOURCE_ATTRIBUTES_NODE_NAME
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: spec.nodeName
- name: OTEL_RESOURCE_ATTRIBUTES_POD_NAME
  valueFrom:
    fieldRef:
      apiVersion: v1
      fieldPath: metadata.name
- name: OTEL_RESOURCE_ATTRIBUTES
  value: 'k8s.namespace.name=$(OTEL_K8S_NAMESPACE),k8s.node.name=$(OTEL_RESOURCE_ATTRIBUTES_NODE_NAME),k8s.pod.name=$(OTEL_RESOURCE_ATTRIBUTES_POD_NAME)'
{{- end -}}
{{- end -}}
