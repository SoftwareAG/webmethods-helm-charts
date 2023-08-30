{{/*
Generate metering environment entries for Software AG products.

Usage:
{{ include "common.medctering.envs" (dict "metering" $) }}
*/}}

{{- define "common.metering.envs" -}}
  - name: "METERING_SERVER_URL"
    value: "{{ .Values.metering.serverUrl }}"
  - name: "METERING_PROXY_TYPE"
    value: "{{ .Values.metering.proxyType }}"
  - name: "METERING_PROXY_ADDRESS"
    value: "{{ .Values.metering.proxyAddress }}"
  - name: "METERING_SERVER_CONNECT_TIMEOUT"
    value: "{{ .Values.metering.serverConnectTimeout }}"
  - name: "METERING_SERVER_READ_TIMEOUT"
    value: "{{ .Values.metering.serverReadTimeout }}"
  - name: "METERING_ACCUMULATION_PERIOD"
    value: "{{ .Values.metering.accumulationPeriod }}"
  - name: "METERING_REPORT_PERIOD"
    value: "{{ .Values.metering.reportPeriod }}"
  - name: "METERING_RUNTIME_ALIAS"
    value: "{{ .Values.metering.runtimeAlias }}"
  - name: "METERING_LOG_LEVEL"
    value: "{{ .Values.metering.logLevel }}"
{{- end }}