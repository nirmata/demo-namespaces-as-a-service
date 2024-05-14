# Self-Service Namespaces

Add apps or other namespace resources in a YAML file to deploy:

```yaml
applications:
  shared-test:
    project: default
    additionalLabels:
      owner: ned
    source:
      repoURL: 'https://github.com/nirmata/demo-namespaces-as-a-service/'
      path: config/sample-apps/namespace
      targetRevision: HEAD
    destination:
      namespace: test
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