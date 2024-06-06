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
{{- define "apigateway.elasticservice" -}}
{{- default ( printf "%s%s" ( include "common.names.fullname" .) "-es-http" )  .Values.global.elasticsearch.serviceName }}
{{- end }}

{{/*
Build the secret name for Elastic Search user
*/}}
{{- define "apigateway.elasticsecret" -}}
{{- default ( printf "%s%s" ( include "common.names.fullname" .) "-sag-user-es" )  .Values.elasticsearch.secretName }}
{{- end }}

{{/*
Build the secret name for kibana user
*/}}
{{- define "apigateway.kibanasecret" -}}
{{- default ( printf "%s%s" ( include "common.names.fullname" .) "-sag-user-kb" )  .Values.kibana.secretName }}
{{- end }}

{{/*
Build the secret password for truststore for Kibana
*/}}
{{- define "apigateway.kibanatruststorepassword" -}}
{{- default (printf "%s%s" ( include "common.names.fullname" .) "-truststore-password-kb") .Values.kibana.tls.truststorePasswordSecret }}
{{- end }}

{{/*
Build the secret name for keystore for Elasticsearch
*/}}
{{- define "apigateway.elastickeystoresecret" -}}
{{- default (printf "%s%s" (include "common.names.fullname" .) "-es-keystore-secret") .Values.apigw.elastickeyStoreSecretName }}
{{- end }}

{{/*
Build the secret name for truststore for Elasticsearch
*/}}
{{- define "apigateway.elastictruststoresecret" -}}
{{- default (printf "%s%s" (include "common.names.fullname" .) "-es-truststore-secret") .Values.apigw.elastictrustStoreSecretName }}
{{- end }}

{{/*
Renders API Gateway's password key identifier for API Gateway for the keystore. Defaults to "password" if no Value for .Values.apigw.elastic. 
*/}}
{{- define "apigateway.elastickeystoresecretPasswordKey" -}}
  {{- default ( printf "%s" "password" )  .Values.apigw.elastickeyStorePassKey }}
{{- end }}

{{/*
Renders API Gateway's password key identifier for API Gateway for the truststore. Defaults to "password" if no Value for .Values.apigw.elastic. 
*/}}
{{- define "apigateway.elastictruststoresecretPasswordKey" -}}
  {{- default ( printf "%s" "password" )  .Values.apigw.elastictruststoreStorePassKey }}
{{- end }}

{{/* 
Build the tls secret name, which holds the jks trust and keystore for API Gateway to communicate with Elasticsearch
*/}}
{{- define "apigateway.elastictls" -}}
{{- default (printf "%s%s" (include "common.names.fullname" .) "-es-tls-secret") .Values.elasticsearch.tlsSecretName }}
{{- end }}

{{/* 
Build the admin secret name, which holds the Administrator password
*/}}
{{- define "apigateway.adminsecret" -}}
{{- default (printf "%s%s" (include "common.names.fullname" .) "-admin-password") .Values.apigw.adminSecretName }}
{{- end }}

{{/*
Renders the admin secret name for API Gateway from the apigw.adminSecretName value. If not specified, it will be the default name.
*/}}
{{- define "apigateway.adminsecretName" -}}
  {{- default ( printf "%s%s" ( include "common.names.fullname" .) "-admin-password" )  .Values.apigw.adminSecretName }}
{{- end }}

{{/*
Renders the admin secret key name for API Gateway from the apigw.adminsecretKey value. If not specified, it will be the default name.
*/}}
{{- define "apigateway.adminsecretKey" -}}
  {{- default ( printf "%s" "password" )  .Values.apigw.adminSecretKey }}
{{- end }}

{{/*
Renders the Elasticsearch secret key name for API Gateway from the apigw.elasticsecretKey value. If not specified, it will be the default name.
*/}}
{{- define "apigateway.elasticsecretPasswordKey" -}}
  {{- default ( printf "%s" "password" )  .Values.elasticsearch.secretPasswordKey }}
{{- end }}

{{/*
Renders the Elasticsearch secret user name for API Gateway from the apigw.elasticsecretKey value. If not specified, it will be the default name.
*/}}
{{- define "apigateway.elasticsecretUserKey" -}}
  {{- default ( printf "%s" "username" )  .Values.elasticsearch.secretUserKey }}
{{- end }}

{{/*
Renders the license config name or secret. If not specified, it will be the default name.
*/}}
{{- define "apigateway.licenseconfigname" -}}
  {{- default ( printf "%s-%s" (include "common.names.fullname" . ) "license") .Values.licenseConfigName  }}
{{- end }}

{{/*
Renders the service name for service monitoring. If not specified, it will be the default name.
*/}}
{{- define "apigateway.monitorServiceName" -}}
  {{- default ( printf "%s-%s" (include "common.names.fullname" . ) "-rt") .Values.serviceMonitor.serviceName  }}
{{- end }}