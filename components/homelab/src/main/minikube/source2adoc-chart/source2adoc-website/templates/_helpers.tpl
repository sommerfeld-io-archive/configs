{{- define "source2adoc-website.labels" -}}
app.kubernetes.io/name: source2adoc-website
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | default .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "source2adoc-website.selectorLabels" -}}
app.kubernetes.io/name: source2adoc-website
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
