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

{{/*
Return the proper hookJob image name
*/}}
{{- define "clusterpedia.hookJob.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.hookJob.image "global" .Values.global) }}
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

{{- define "clusterpedia.common.featureGates" -}}
  {{- if (not (empty .featureGates)) }}
    {{- $featureGatesFlag := "" -}}
    {{- range $key, $value := .featureGates }}
      {{- if not (empty (toString $value)) }}
        {{- $featureGatesFlag = cat $featureGatesFlag $key "=" $value "," -}}
      {{- end }}
    {{- end }}

    {{- if gt (len $featureGatesFlag) 0 }}
      {{- $featureGatesFlag := trimSuffix "," $featureGatesFlag  | nospace -}}
      {{- printf "%s=%s" "--feature-gates" $featureGatesFlag -}}
    {{- end }}
  {{- end }}
{{- end -}}

{{- define "clusterpedia.storage.configmap.name" -}}
{{- if (include "clusterpedia.storage.override.configmap.name" .) }}
  {{ include "clusterpedia.storage.override.configmap.name" . }}
{{- else if .Values.storage.configmap -}}
  {{- .Values.storage.configmap -}}
{{- else if .Values.storage.config -}}
  {{- printf "%s-%s-%s" (include "common.names.fullname" .) .Values.storage.name "config" | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{- define "clusterpedia.apiserver.env" -}}
{{- if or .Values.apiserver.enableSHA1Cert .Values.storage.componentEnv }}
env:
{{- if .Values.apiserver.enableSHA1Cert }}
- name: GODEBUG
  value: x509sha1=1
{{- end }}
{{- if (include "clusterpedia.storage.override.componentEnv" .) }}
{{ include "clusterpedia.storage.override.componentEnv" . }}
{{- else if .Values.storage.componentEnv }}
{{ toYaml .Values.storage.componentEnv }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "clusterpedia.clustersynchroManager.env" -}}
{{- if or .Values.storage.componentEnv (include "clusterpedia.storage.override.componentEnv" .) }}
env:
{{- if (include "clusterpedia.storage.override.componentEnv" .) }}
{{ include "clusterpedia.storage.override.componentEnv" . }}
{{- else if .Values.storage.componentEnv }}
{{ toYaml .Values.storage.componentEnv }}
{{- end }}
{{- end }}
{{- end -}}

{{- define "clusterpedia.storage.initContainers" -}}
{{- if (include "clusterpedia.storage.override.initContainers" .) }}
{{ include "clusterpedia.storage.override.initContainers" . }}
{{- end }}
{{- end -}}