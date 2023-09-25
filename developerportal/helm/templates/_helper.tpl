# /*
#  * Copyright (c) 2021 Software AG, Darmstadt, Germany and/or its licensors
#  *
#  * SPDX-License-Identifier: Apache-2.0
#  *
#  *   Licensed under the Apache License, Version 2.0 (the "License");
#  *   you may not use this file except in compliance with the License.
#  *   You may obtain a copy of the License at
#  *
#  *       http://www.apache.org/licenses/LICENSE-2.0
#  *
#  *   Unless required by applicable law or agreed to in writing, software
#  *   distributed under the License is distributed on an "AS IS" BASIS,
#  *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  *   See the License for the specific language governing permissions and
#  *   limitations under the License.
#  *
#  */
{{/*
Build the elasticsearch service name
*/}}
{{- define "developerportal.elasticservice" -}}
{{- default ( printf "%s%s" ( include "common.names.fullname" .) "-es-http" )  .Values.elasticsearch.serviceName }}
{{- end }}

{{/*
Build the elasticsearch service name
*/}}
{{- define "developerportal.kibanaservice" -}}
{{- default ( printf "%s%s" ( include "common.names.fullname" .) "-kb-http" )  .Values.kibana.serviceName }}
{{- end }}

{{/*
Build the secret name for Elastic Search user
*/}}
{{- define "developerportal.elasticsecret" -}}
{{- default ( printf "%s%s" ( include "common.names.fullname" .) "-sag-user" )  .Values.elasticsearch.secretName }}
{{- end }}

{{/*
Build the secret name for trust and keystore for Elasticsearch
*/}}
{{- define "developerportal.elastickeystoresecret" -}}
{{- default (printf "%s%s" (include "developerportal.elasticsecret" .) "-keystore") .Values.elasticsearch.keystoreSecretName }}
{{- end }}

{{/* 
Build the tls secret name, which holds the jks trust and keystore for API Gateway to communicate with Elasticsearch
*/}}
{{- define "developerportal.elastictls" -}}
{{- default (printf "%s%s" (include "common.names.fullname" .) "-es-tls-secret") .Values.elasticsearch.tlsSecretName }}
{{- end }}