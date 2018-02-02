# Before You Begin

For this solution, you will need:

* An account on [Microsoft Azure](https://azure.microsoft.com). You can
create your Azure account for [free](https://azure.microsoft.com/en-us/free/)

* Azure CLI 2.0 (more instructions below)

## Microsoft Azure CLI 2.0

### Install the Microsoft Azure CLI 2.0

Follow the Azure CLI 2.0 [documentation](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) to install the `az` command line utility. You can install utility in various platforms such as macOS, Window
s, Linux (various distros) and as a Docker container.

The examples here are based on the version 2.0.18 of the utility. You can verify the version of the tool by running:

```
az --version
```

> Note: If this is your first time using the Azure CLI tool, you can familiarize yourself with it's syntax and command options by running `az interactive`

### First Things First

Before we can use Azure, your first step, aside from having an account, is to login. Once Azure CLI is installed, open up a terminal and run the following:

```
az login
```

This will prompt you to sign in using a web browser to https://aka.ms/devicelogin and to enter the displayed code. This single step is needed in order to allow `az` to talk back to Azure.

## Basic setup - Do this before proceeding

The first thing you should do is to clone this repo as most of the examples here will do relative reference to files.

```bash
git clone https://github.com/dcasati/k8s-training.git
```

With that out of the way, we let's define some global variables. They will be used throughout the labs.

1. Create the variables file

    ```bash
    # The name of our demo
    export demoname=k8s-demo
    cat << EOF > variables.rc
    # The data center and resource name for your resources
    export resourcegroupname=${demoname}-rg
    export location=eastus
    # The logical server name: Use a random value or replace with your own value (do not capitalize)
    export servername=${demoname}-$RANDOM
    # Set an admin login and password for your database
    export adminlogin=ServerAdmin
    export password=PleaseChangeMe1
    # The ip address range that you want to allow to access your DB
    export startip="0.0.0.0"
    export endip="0.0.0.0"
    # The database name
    export databasename=${demoname}
    # Azure Container Registry
    export acrname=${demoname/-/}acr$RANDOM
    EOF
    ```
> NOTE: Make sure you change the `adminlogin` and `password` values to avoid unnecessary surprises.

1. source it to load the values
    ```bash
   source variables.rc
    ```
1. With these values, we can now create a Resource Group that will be used during our exercises.

```bash
az group create \
    --name $demoname \
    --resource-group $resourcegroupname \
    --location $location
```

Next: [Configuring Azure SQL](02-configuring-azure-sql.md)
