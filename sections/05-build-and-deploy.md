# Build and Deploy the Application

In this section we will see how to create Secrets, ConfigMaps and how to deploy our REST API application to a Kubernetes cluster.

## Create the Secrets

To allow the REST API application access to the database, we will use a feature called `secrets` on Kubernetes. For that, we will create a directory with two files: `username` and `password`. 

> These values are the `$adminlogin` and `$password` values previously defined for the Azure SQL database on the section [Before You Begin](sections/01-before-you-begin.md).

1. Create the secrets directory with the username and password files

    ```bash
    mkdir secrets
    cd secrets
    echo $adminlogin > username
    echo $password > password
    ```

```bash
kubectl create secret generic api-server-credentials --from-file=./username password --from-file=./password
```

### Create the ConfigMaps
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