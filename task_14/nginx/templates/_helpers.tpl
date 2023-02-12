{{- define "nginxchart.labels" -}}
app: {{ .Release.Name }}
{{- end -}}
