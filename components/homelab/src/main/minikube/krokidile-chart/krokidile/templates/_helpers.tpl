{{- define "krokidile.labels" -}}
app.kubernetes.io/name: krokidile
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | default .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "krokidile.selectorLabels" -}}
app.kubernetes.io/name: krokidile
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "krokidile_docs.labels" -}}
app.kubernetes.io/name: krokidile-docs
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | default .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "krokidile_docs.selectorLabels" -}}
app.kubernetes.io/name: krokidile-docs
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}
