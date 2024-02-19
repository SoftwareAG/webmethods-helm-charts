# Using of Stakater Reloader

Per default, the Microservices Runtime pod is not restarted on unchanged `application.properties` file between Helm release upgrades. The [Stakataer Reloader](https://github.com/stakater/Reloader) can solve and help this issue.

## Increase `values.yaml`

Add following value in `podAnnotations` to define the dependency between deployment and config map ...

```
podAnnotations:
  configmap.reloader.stakater.com/reload: "{{ include \"common.names.fullname\" . }}"
```

If the ConfigMap (evaluated by `{{ include \"common.names.fullname\" . }}`) with `application.properties` file is changed, [Stakataer Reloader](https://github.com/stakater/Reloader) restarts the pod.