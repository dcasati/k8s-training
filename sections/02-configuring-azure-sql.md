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
    > OUTPUT:
    ```bash
    {
    "administratorLogin": "ServerAdmin",
    "administratorLoginPassword": null,
    "fullyQualifiedDomainName": "k8s-demo-13980.database.windows.net",
    "id": "/subscriptions/0000000-0000-0000-0000-00000/resourceGroups/k8s-demo-rg/providers/Microsoft.Sql/servers/k8s-demo-13980",
    "identity": null,
    "kind": "v12.0",
    "location": "eastus",
    "name": "k8s-demo-13980",
    "resourceGroup": "k8s-demo-rg",
    "state": "Ready",
    "tags": null,
    "type": "Microsoft.Sql/servers",
    "version": "12.0"
    }
    ````

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
        --name $demoname-db \
        --resource-group $resourcegroupname \
        --sample-name AdventureWorksLT \
        --server $servername \
        --service-objective S0
    ```
    OUTPUT:
    ```bash
    {
        "collation": "SQL_Latin1_General_CP1_CI_AS",
        "containmentState": 2,
        "createMode": null,
        "creationDate": "2018-02-02T17:17:50.783000+00:00",
        "currentServiceObjectiveId": "f1173c43-91bd-4aaa-973c-54e79e15235b",
        "databaseId": "697bdf8b-830a-4713-8245-4c25ed916b70",
        "defaultSecondaryLocation": "West US",
        "earliestRestoreDate": "2018-02-02T17:48:31.253000+00:00",
        "edition": "Standard",
        "elasticPoolName": null,
        "failoverGroupId": null,
        "id": "/subscriptions/00000-0000-000-0000-00000/resourceGroups/k8s-demo-rg/providers/Microsoft.Sql/servers/k8s-demo-13980/databases/k8s-demo-db",
        "kind": "v12.0,user",
        "location": "East US",
        "maxSizeBytes": "268435456000",
        "name": "k8s-demo-db",
        "readScale": "Disabled",
        "recommendedIndex": null,
        "recoveryServicesRecoveryPointResourceId": null,
        "requestedServiceObjectiveId": "f1173c43-91bd-4aaa-973c-54e79e15235b",
        "requestedServiceObjectiveName": "S0",
        "resourceGroup": "k8s-demo-rg",
        "restorePointInTime": null,
        "sampleName": null,
        "serviceLevelObjective": "S0",
        "serviceTierAdvisors": null,
        "sourceDatabaseDeletionDate": null,
        "sourceDatabaseId": null,
        "status": "Online",
        "tags": null,
        "transparentDataEncryption": null,
        "type": "Microsoft.Sql/servers/databases",
        "zoneRedundant": false
    }
    ```
 Next: [Creating a Docker image](03A-creating-an-image.md)