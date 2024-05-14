# Namespace with a Quota

Deploy a namespace `test` using:

```yaml
applications:
  shared-test:
    source:
      repoURL: 'https://github.com/nirmata/demo-namespaces-as-a-service/'
      path: config/apps/namespace
      targetRevision: HEAD
    destination:
      namespace: test
```
