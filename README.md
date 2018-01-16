# Kubernetes Training: End-to-End Experience.

This tutorial walks you through and end-to-end deployment of an application to a Kubernetes cluster.

> The results of this tutorial should not be viewed as production ready, and may receive limited support from the community, but don't let that stop you from learning!

## Target Audience

The target audience for this tutorial is someone that is looking for an end-to-end hands-on experience for deploying an application into a Kubernetes cluster.

## Solution Details

1. Provision Azure SQL.
1. Provision Azure Container Registry (ACR) or Docker Hub.
1. Setup ACR in the K8S cluster.
1. Push the containers into ACR.
1. Build  & Deploy the application.
1. Setup a CI/CD on VSTS. 

## Prerequisites

This tutorial assumes you have access to a Kubernetes Cluster. The examples here will use [Microsoft Azure](https://azure.microsoft.com/en-us/). While Azure is used for basic infrastructure requirements the lessons learned in this tutorial can be applied to other platforms.


## Creating Secrets
```bash
kubectl create secret generic api-server-credentials --from-file=./username password --from-file=./password
```

### Creating ConfigMaps
```bash
kubectl create configmap api-server-config --from-file=config
```
