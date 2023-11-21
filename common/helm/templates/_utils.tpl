{{/*
Render nested maps and strings with proper indentation. Strings are rendered as templates.
*/}}
{{- define "common.utils.renderNestedMap" -}}
  {{- $ctx := .ctx -}} 
  {{- $depth := .depth -}} 
  {{- range $key, $value := .map }}
    {{- if kindIs "map" $value }}
    {{- printf "%s:" $key | nindent $depth }}
    {{- include "common.utils.renderNestedMap" (dict "map" $value "ctx" $ctx "depth" (int (add $depth 2))) }}
    {{- else if kindIs "string" $value }}
    {{- printf "%s: %s" $key (tpl $value $ctx) | nindent $depth }}
    {{- else if or (kindIs "bool" $value) (or (kindIs "float" $value) (kindIs "int" $value)) }}
    {{- printf "%s: %v" $key $value | nindent $depth }}
    {{- end }}
  {{- end }}
{{- end }}