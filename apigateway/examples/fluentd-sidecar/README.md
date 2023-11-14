# Running API Gateway with Fluentd Sidecar

This sample shows how to run API Gateway with a Fluentd sidecar container. This sample will use the "naked" fluentd docker image with no plugins. The fluentd sidecar container will be configured to collect the API Gateway logs from ```/opt/softwareag/IntegrationServer/instances/default/logs``` and send them to a stdout. For more sophisticated logging, you can use a different fluentd image and configure it to send the logs to a log aggregator such as Elasticsearch.

## Prerequisites

The fluentd sidecar container requires a fluentd configuration file. This sample uses the [fluentd.conf](fluentd.conf) file. The fluentd configuration file is mounted as a volume in the fluentd sidecar container and provided through the sample values file.

## Installing the Chart

To install the chart with the release name `apigw` in the namespace `apigw`:

```bash
helm install apigw webmethods-helm-charts/apigateway \
  --values webmethods-helm-charts/apigateway/examples/fluentd-sidecar/values.yaml \
  -n apigw \
  --create-namespace
```

## Uninstalling the Chart

To uninstall/delete the `apigw` deployment:

```bash
helm uninstall apigw -n apigw
```

## Building a custom fluentd image

To build a custom fluentd image, you can use the [Dockerfile](Dockerfile) provided in this sample. The Dockerfile will install fluentd plugins for collecting logs from API Gateway and send them to a log aggregator such as Elasticsearch. 

## Sample Dockerfile

```Dockerfile
# Use Fluentd base image
FROM fluent/fluentd:v1.16.2-debian-1.0

# Use root user for installation
USER root

# Install required plugins
RUN fluent-gem install fluent-plugin-record-modifier fluent-plugin-detect-exceptions fluent-plugin-elasticsearch

# Switch to non-root user
USER fluent
```

## Sample fluentd configuration file

The sample fluentd configuration file [fluentd.conf](fluentd.conf) is provided below. The configuration file is mounted as a volume in the fluentd sidecar container and provided through your values file (extraConfigMaps). The sample fluentd.config uses the following plugins:

* [fluent-plugin-record-modifier]() to modify the loglevel prefix to loglevel
* [fluent-plugin-detect-exceptions]() to detect multiline exceptions
* [fluent-plugin-elasticsearch]() to send the logs to Elasticsearch


```yaml
# Sample Fluentd config, edit as per your needs.
# https://github.com/fluent/fluentd-kubernetes-daemonset/tree/master/templates/conf has some good fluentd config examples

<system>
  log_level info
</system>

# Prevent fluentd from handling records containing its own logs to handle cycles.
<label @FLUENT_LOG>
  <match fluent.**>
    @type null
  </match>
</label>

# reads the log files from the wm_server_log path
<source>
  @type tail
  @id wm_server_log
  path /var/log/wm/server.log
  path_key tailed_path
  pos_file /fluentd/log/fluentd-server-log.pos
  read_from_head true
  follow_inodes true
  enable_stat_watcher false
  refresh_interval 5s
  tag tmptag.wm_server_log
  <parse>
    @type multiline
    format_firstline /^(?<logtime>\S+\ \S+)\ (?<timezone>\S+)/
    format1 /^(?<logtime>\S+\ \S+)\ (?<timezone>\S+)\ (?<loglevelprefix>.*?)(?<loglevel>.{1})(?<msg>.{1})\ (?<msg1>.*)/
  </parse>
</source>

# Replaces the loglevel prefix with the loglevel (Info, Warn, Critical, Error)
<filter tmptag.wm_server_log>
  @type record_modifier
  <replace>
    key loglevel
    expression /^I/
    replace 'Info'
  </replace>
  <replace>
    key loglevel
    expression /^W/
    replace 'Warn'
  </replace>
  <replace>
    key loglevel
    expression /^C/
    replace 'Critical'
  </replace>
  <replace>
    key loglevel
    expression /^E/
    replace 'Error'
  </replace>
</filter>

# takes the loglevelprefix and replaces it with the loglevel (Info, Warn, Critical, Error)
<source>
  @type tail
  @id wm_configurationvariables_log
  path /var/log/wm/configurationvariables.log
  path_key tailed_path
  pos_file /fluentd/log/configurationvariables-log.pos
  read_from_head true
  follow_inodes true
  enable_stat_watcher false
  refresh_interval 5s
  tag tmptag.wm_configurationvariables_log
  <parse>
    @type regexp
    expression ^(?<logtime>\S+\ \S+)\ (?<timezone>\S+)\ (?<loglevelprefix>.*?)(?<loglevel>.{1})(?<msg>.{1})\ (?<msg1>.*)
  </parse>
</source>

# Replaces the loglevel prefix with the loglevel (Info, Warn, Critical, Error) from the configurationvariables.log
<filter tmptag.wm_configurationvariables_log>
  @type record_modifier
  <replace>
    key loglevel
    expression /^I/
    replace 'Info'
  </replace>
  <replace>
    key loglevel
    expression /^W/
    replace 'Warn'
  </replace>
  <replace>
    key loglevel
    expression /^C/
    replace 'Critical'
  </replace>
  <replace>
    key loglevel
    expression /^E/
    replace 'Error'
  </replace>
</filter>

# Enriches the record with the hostname
<filter **>
  @type record_transformer
  <record>
    service apigw-1015
    hostname ${hostname}
    # add addtional fields here
  </record>
</filter>

# Enriches the record with the kubernetes metadata
<match tmptag.*>
  @type detect_exceptions
  remove_tag_prefix tmptag
  multiline_flush_interval 1
  message message
  force_line_breaks true
  @label @OUT_COPY
</match>

# Sends the records to an Elasticsearch server
<label @OUT_COPY>
  <match **>
    @type copy
    <store>
      @type elasticsearch
      @id out_es_all_container_logs
      host "elasticsearch-host"  # Replace with your Elasticsearch host
      port 9200                 # Replace with your Elasticsearch port
      scheme "http"             # Use "https" for HTTPS
      ssl_verify false          # Set to true if using HTTPS and you want to verify the server's certificate
      # Specify the index name patterns
      index_name fluentd        # Replace with your desired index name
      type_name _doc            # For Elasticsearch 7.x, use "_doc"
      logstash_format true      # Set to true to enable Logstash compatible index names
      # Optional: Customize connection
      reconnect_on_error true
      reload_connections false
      # Optional: User authentication (remove if not using authentication)
      user "your_username"      # Replace with your Elasticsearch username
      password "your_password"  # Replace with your Elasticsearch password
    </store>
  </match>
</label>

```