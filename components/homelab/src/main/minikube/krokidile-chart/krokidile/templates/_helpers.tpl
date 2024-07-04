{{- define "krokidile.fullname" -}}
{{- .Release.Name | printf "%s-%s" .Chart.Name -}}
{{- end -}}

{{- define "krokidile.labels" -}}
app.kubernetes.io/name: {{ include "krokidile.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | default .Chart.Version }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "krokidile.selectorLabels" -}}
app.kubernetes.io/name: {{ include "krokidile.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "krokidile.name" -}}
{{- .Chart.Name | printf "%s" -}}
{{- end -}}
