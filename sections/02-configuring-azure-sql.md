# Configuring Azure SQL

In this section you will configure an instance of Azure SQL. This will be used as the backend for our REST API server.

1. Create a server

    ```bash
    az sql server create \
        --name $servername \
        --resource-group $resourcegroupname \
        --location $location \
        --admin-user $adminlogin \
        --admin-password $password
    ```

1. Allow access to the database

    ```bash
    az sql server firewall-rule create \
        --resource-group $resourcegroupname \
        --server $servername \
        -n AllowYourIp \
        --start-ip-address $startip \
        --end-ip-address $endip
    ```

1. Create the Azure SQL database populated with a sample information from the AdventureWorksLT.

    ```bash
    az sql db create \
        --name my-k8s-demo \
        --resource-group k8s-demo \
        --sample-name AdventureWorksLT \
        --server k8s-demo \
        --service-objective S0
    ```

 Next: [Configuring Azure Container Registry](03-configuring-acr.md)
