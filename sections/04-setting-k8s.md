# Setting up Kubernetes

Here we will see the steps needed to setup a Kubernetes cluster on Azure.

> NOTE: At the time of this writing, Azure Container Services is in preview so before you can use it you will have to add that feature to your subscription with the following command:
    
```bash
az provider register -n Microsoft.ContainerService
```

## Procedure

1. Create an AKS instance

    ```bash
    az aks create \
        --resource-group $resourcegroupname \
        --name $demoname-cluster \
        --node-count 2 \
        --generate-ssh-keys
    ```
    After a few minutes you should have you cluster up and running.

1. To install kubectl

    ```bash
    az aks install-cli
    ```
    > NOTE: This procedure will work on MacOS, Linux and Windows.

1. Run the following az command:

    ```bash
    az aks get-credentials \
    --resource-group $resourcegroupname \
    --name $demoname-cluster
    ```
    This will get the `KUBECONFIG` so you can later use with kubectl

1. To test your new setup, let's get the information about the PODs and Nodes.

    ```bash
    kubectl get pods,nodes 
    ```
## Going further

1. Access the Kubernetes UI
    ```bash
    kubectl proxy
    ```
OUTPUT:

```bash
kubectl proxy
Starting to serve on 127.0.0.1:8001
```
    
Next: [Build and Deploy the Application](05-build-and-deploy.md)
