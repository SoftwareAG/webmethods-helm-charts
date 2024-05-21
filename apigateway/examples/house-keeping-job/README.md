# House Keeping Job - Purge Transaction Events

The examples in [values.yaml](./values-purge-transaction-events-job.yaml) creates a Kubernetes cron job to purge transaction events of all types which are older than specific days.

## Job Template and `DEPLOYMENT` Environment Variable

The [Job template](../../helm/templates/job.yaml) is used to create a Kubernetes (Cron) Job object. A feature of this template is to set the environment variable `DEPLOYMENT` with the full deployment name. The deployment name is equal to the Kubernetes service name.
