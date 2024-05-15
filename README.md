# Self-Service Namespaces with Policy as Code (PaC)

This repository contains a demo of self-service namespaces (aka namespaces-as-a-service) and apps, using ArgoCD for GitOps and Kyverno for Policy as Code (PaC).

The setup runs ArgoCD on its own `hub` cluster and creates namespaces and applications on a `shared` cluster. For the demo, we will use `kind` clusters for both. In a production setup the `shared` cluster will have auto-scalers for resizing.

## Installation

1. Install [kind](https://kind.sigs.k8s.io/) and create a cluster for ArgoCD:

```sh
kind create cluster --name argocd
```

2. Install and configure ArgoCD

```sh
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
```

```sh
kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
```

```sh
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo
```

```sh
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

```sh
 argocd login 127.0.0.1:8080 --username admin --password <SECRET>
```

Navigate to: https://127.0.0.1:8080/

Install the [argocd CLI](https://argo-cd.readthedocs.io/en/stable/cli_installation/) and login:

```sh
argocd login localhost:8080 --username admin --password <SECRET>
```

Update the ArgoCD ConfigMap to track resources based on annotations. 
This is required to clean up self-service namespaces:

https://github.com/argoproj/argo-cd/issues/7875#issuecomment-1954504713

```sh
kubectl -n argocd patch configmap argocd-cm --type merge -p '{"data":{"application.resourceTrackingMethod": "annotation+label"}}'
```

```sh
kubectl -n argocd patch configmap argocd-cm --type merge -p '{"data":{"application.instanceLabelKey": "argocd.argoproj.io/instance"}}'
```


Install ArgoCD application sets

```sh
kubectl apply -f config/argocd-cluster/appsets/
```

3. Install and configure Kyverno

Install latest Kyverno (not recommended for production):

```sh
kubectl create -f https://github.com/kyverno/kyverno/raw/main/config/install-latest-testing.yaml
```

Install Kyverno policies for the `argocd` cluster:

```sh
kubectl apply -f config/argocd-cluster/roles/
```

```sh
kubectl apply -f config/argocd-cluster/policies/
```

4. Create a shared cluster

To allow ArgoCD on the `argocd` cluster to communicate with the `shared` cluster, the `shared` cluster needs to be configured to use an external IP address i.e. your local machine address.

Run this script to create a kind configuration:

```sh
./config/shared-cluster/kind/create.sh
```

Create the kind cluster:

```sh
kind create cluster --name shared --config /tmp/kind-config.yaml
```

Register the kind cluster with ArgoCD:

```sh
argocd cluster add kind-shared  -y
```

5. Create secure self-service apps and namespaces 

When the shared cluster is registered with ArgoCD a secret is created. The Kyverno policy [create-cluster-appset.yaml](config/argocd-cluster/policies/create-cluster-appset.yaml) watches the secret and will automatically create an `ApplicationSet` that watches a Git directory `https://github.com/nirmata/demo-namespaces-as-a-service/tree/main/kind-shared` for new values file with requests for applications. 

**NOTE: If you fork the repository, please update the policy to point to your own location for the Git commits.**

Check-in `Applications` or `ApplicationSets` to the `https://github.com/nirmata/demo-namespaces-as-a-service/tree/main/kind-shared` respository.

See [sample-apps](https://github.com/nirmata/demo-namespaces-as-a-service/tree/main/config/sample-apps) for examples.

## Cleanup

To cleanup, delete the two kind clusters:

```sh
kind delete cluster --name shared
kind delete cluster --name argocd
```
