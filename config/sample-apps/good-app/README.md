# Busybox Sample Application

Deploy a Busybox application:

```yaml
applications:
  shared-busybox:
    project: default
    additionalLabels:
      owner: nancy    
    source:
      repoURL: 'https://github.com/nirmata/demo-namespaces-as-a-service'
      path: config/sample-apps/good-app
      targetRevision: HEAD
    destination:
      namespace: busybox
```

