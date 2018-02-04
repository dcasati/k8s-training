# Configuring the Azure Container Registry (ACR)
In this section, we will setup our private registry on Azure Container Registry. If you are using a public registry such as [Docker Hub](https://hub.docker.com) you can skip this section.

## Prerequisites

* Before going ahead with this section, make sre you have `Docker` installed.

## Create a Dockerfile for the REST API server and publish it to ACR

Now that we know the basics of how to create, publish, run and list our Docker images, let's use a more practical example. The following Dockerfile will be used to create our REST API server. You can either use the file available on this repo or create a new one as a learning exercise.

## Procedure

1. Create a directory

    ```bash
    mkdir k8s_app && cd k8s_app
    ```
1. Create the Dockerfile
    ```bash
    cat << 'EOF' > Dockerfile
    # Based on the work of lbosqmsft 
    # https://hub.docker.com/r/lbosqmsft/mssql-python-pyodbc/

    # mssql-python-pyodbc
    # Python runtime with pyodbc to connect to SQL Server
    FROM ubuntu:16.04

    # apt-get and system utilities
    RUN apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y \
            apt-utils \
            apt-transport-https \
            build-essential \
            curl \
            debconf-utils \
            gcc \
            g++-5\
        && rm -rf /var/lib/apt/lists/*

    # adding custom MS repository
    RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
        && curl https://packages.microsoft.com/config/ubuntu/16.04/prod.list >\
            /etc/apt/sources.list.d/mssql-release.list

    # install SQL Server drivers
    RUN apt-get update \
        && DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y \
            apt-get install -y msodbcsql unixodbc-dev

    # install SQL Server tools
    RUN apt-get update \
        && DEBIAN_FRONTEND=noninteractive ACCEPT_EULA=Y \
            apt-get install -y mssql-tools \
        && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc \
        && /bin/bash -c "source ~/.bashrc"

    # python libraries
    RUN apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y \
            python3-dev \
            python3-pip \
            python3-setuptools --no-install-recommends \
        && rm -rf /var/lib/apt/lists/*

    # install necessary locales
    RUN apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y locales \
        && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
        && locale-gen

    # add sample code
    COPY python-flask-server/ /app

    RUN mkdir -p /app \
        && pip3 install --upgrade pip \
        && pip3 install --no-cache-dir -r /app/requirements.txt

    WORKDIR /app
    EXPOSE 8080

    ENTRYPOINT ["python3"]

    CMD ["-m", "swagger_server"]
    EOF
    ```
    1. Build the image
    ```bash
    docker build -t k8s_app:v1 .
    ```

## Setup Azure Container Registry
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
    > Note: Save the value of the `loginServer` to a variable of the same name ($loginServer).
    ```bash
    loginServer=$(az acr list --resource-group $resourcegroupname --query "[].{acrLoginServer:loginServer}" --output tsv)
    ```

1. Login into ACR

    ```bash
    az acr login --name $acrname
    ```
1. Tag the `k8s_app` image

    ```bash
    docker tag k8s_app:v1 $loginServer/k8s_app:v1
    ``` 
1. Now lets push our docker image to ACR
    ```bash
    docker push $loginServer/k8s_app:v1
    ```

1. List the images registered

    ```bash
    az acr repository list --name $acrname --output table
    ```
> TIP: You might be running the above command frequently, so to save some keystrokes here's a good shortcut.
```bash
acr-list()(az acr repository list --name $acrname --output table)
```
Now everytime you need to see what's registered on your ACR repository you can just type `acr-list`.

Next: [Setting up Kubernetes](04-setting-k8s.md)