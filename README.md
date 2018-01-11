kubectl create secret generic api-server-credentials --from-file=./username password --from-file=./password
kubectl create configmap api-server-config --from-file=config
