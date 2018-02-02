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
