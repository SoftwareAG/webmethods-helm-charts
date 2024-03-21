# Configure Master Password

## Prerequisites

MSR/IS image is created on 10.15 Core Fix 8.

## `values.yaml`

Since MSR/IS 10.15 Core Fix 8 is it possible to configure the Master password at startup time using environment variable `SAG_IS_MASTER_PASSWORD_KEY`. You can add environment variables with `extraEnvs` ...

```
extraEnvs:
  - name: SAG_IS_MASTER_PASSWORD_KEY
    valueFrom:
      secretKeyRef:
        name: msr-default-master-password
        key: password-key
```
