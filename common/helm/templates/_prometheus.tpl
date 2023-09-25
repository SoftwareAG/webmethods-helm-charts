{{/*
Prometheus annotations
Params:
    - path - String. Name of an existing service backend
    - port - String/Int. Port name (or number) of the service. It will be translated to different yaml depending if it is a string or an integer.
    - scrape - Dict - Required. The context for the template evaluation.
    - path - Dict - Required. The context for the template evaluation.    
*/}}
{{- define "common.prometheus.annotations" -}}
{{- $port := default "5555" .port -}}
{{- $scrape := default "true" .scrape -}}
{{- $scheme := default "http" .scheme -}}
{{- $path := default "/metrics" .path -}}
prometheus.io/scrape: {{ $scrape | quote }}
prometheus.io/path: {{ $path | quote  }} 
prometheus.io/port: {{ $port | quote }}
prometheus.io/scheme: {{ $scheme | quote }}
{{- end -}}
