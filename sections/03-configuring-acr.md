# Configuring Azure Container Registry
In this section, we will setup our private registry on Azure Container Registry. If you are using a public registry such as [Docker Hub](https://hub.docker.com) you can skip this section. 

## Procedure

1. Create an ACR instance

    ```bash
    az acr create \
        --resource-group $resourcegroupname \
        --name $acrname \
        --sku Basic
    ```
    OUTPUT:
    ```bash
    {
        "adminUserEnabled": false,
        "creationDate": "2018-02-02T17:23:16.264759+00:00",
        "id": "/subscriptions/00000-000-0000-0000-0/resourceGroups/k8s-demo-rg/providers/Microsoft.ContainerRegistry/registries/k8sdemoacr15022",
        "location": "eastus",
        "loginServer": "k8sdemoacr15022.azurecr.io",
        "name": "k8sdemoacr15022",
        "provisioningState": "Succeeded",
        "resourceGroup": "k8s-demo-rg",
        "sku": {
            "name": "Basic",
            "tier": "Basic"
        },
        "status": null,
        "storageAccount": null,
        "tags": {},
        "type": "Microsoft.ContainerRegistry/registries"
    }
    ```
1. Login into ACR

    ```bash
    az acr login --name $acrname
    ```
1. Now lets push our docker image to ACR
    ```bash
    docker push <acrLoginServer>/k8s_app:v1
    ```

1. List the images registered

    ```bash
    az acr repository list --name $acrname --output table
    ```

Next: [Setting up Kubernetes](04-setting-k8s.md)
