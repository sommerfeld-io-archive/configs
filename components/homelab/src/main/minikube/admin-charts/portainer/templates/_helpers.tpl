{{- define "portainer.labels" -}}
app.kubernetes.io/name: portainer
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | default .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "portainer.selectorLabels" -}}
app.kubernetes.io/name: portainer
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
