# Busybox Sample Application

Deploy a Busybox application:

```yaml
applications:
  shared-busybox:
    source:
      repoURL: 'https://github.com/nirmata/demo-namespaces-as-a-service'
      path: config/sample-apps/busybox
      targetRevision: HEAD
      kustomize:
        images:
        - 'busybox:latest'
    destination:
      namespace: busybox
```

