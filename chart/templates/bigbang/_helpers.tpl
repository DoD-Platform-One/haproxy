{{/*
Bigbang labels
*/}}
{{- define "bigbang.labels" -}}
app: {{ template "haproxy.name" . }}
{{- if .Chart.AppVersion }}
version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end }}