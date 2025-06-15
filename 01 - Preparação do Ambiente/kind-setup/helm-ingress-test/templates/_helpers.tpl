{{- define "nginx-chart.name" -}}
nginx-chart
{{- end }}

{{- define "nginx-chart.fullname" -}}
{{ printf "%s" (include "nginx-chart.name" .) }}
{{- end }}
