# Build and Deploy the Application

In this section we will see how to create Secrets, ConfigMaps and how to deploy our REST API application to a Kubernetes cluster.

## Create the Secrets

To allow the REST API application access to the database, we will use a feature called `secrets` on Kubernetes. For that, we will create a directory with two files: `username` and `password`.

> These values are the `$adminlogin` and `$password` values previously defined for the Azure SQL database on the section [Before You Begin](01-before-you-begin.md).

1. Create the `secrets` directory with the username and password files

    ```bash
    mkdir secrets
    echo $adminlogin > secrets/username
    echo $password > secrets/password
    ```
1. Create the secrets

    ```bash
    kubectl create secret generic api-server-credentials --from-file=./username password --from-file=./password
    ```

### Create the ConfigMaps

Another construct on Kubernetes is called ConfigMaps which allows you to detach a configuration from your application. We will use a ConfigMap to store the values of our database and database URI. ConfigMaps are similar to Secrets in a sense that they store information that can later be used by Kubernetes.

1. Create a `config` directory with two files: `database` and `server`

    ```bash
    mkdir config
    echo $databasename > config/database
    echo $servername > config/server
    ```
1. Create the configmap
    ```bash
    kubectl create configmap api-server-config --from-file=config
    ```
## Deploying the application to our cluster

1. Create a Kubernetes service
    ```bash
    kubectl apply -f k8s/api-server-svc.yml
    ```
1. Deploy the application
    ```bash
    kubectl apply -f k8s/api-server-deployment.yml
    ```
Next: [Setting up a CI/CD pipeline](https://github.com/dcasati/pipelines-cookbook/blob/master/chapter1.md)