# Use Fluentd base image
FROM fluent/fluentd:v1.16.2-debian-1.0

# Use root user for installation
USER root

# Install required plugins
RUN fluent-gem install fluent-plugin-record-modifier fluent-plugin-detect-exceptions fluent-plugin-vmware-loginsight

# Switch to non-root user
USER fluent
