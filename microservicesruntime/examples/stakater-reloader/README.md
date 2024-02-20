# Using of Stakater Reloader

Per default, the Microservices Runtime pod is not restarted on changed `application.properties` (in *ConfigMap*) between Helm release upgrades. The [Stakataer Reloader](https://github.com/stakater/Reloader) can solve and help this issue.

## Increase `values.yaml`

Add following annotation value in `podAnnotations` to define the dependency between deployment and *ConfigMap*  ...

```
podAnnotations:
  configmap.reloader.stakater.com/reload: "{{ include \"common.names.fullname\" . }}"
```

If the *ConfigMap* (evaluated by `{{ include \"common.names.fullname\" . }}`) with the content of `application.properties` is changed, [Stakataer Reloader](https://github.com/stakater/Reloader) restarts the pod after installing Helm release.