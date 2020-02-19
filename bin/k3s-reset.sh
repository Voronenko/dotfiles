#!/bin/bash

k3s kubectl delete deployments --all
k3s kubectl delete configmaps --all
#k3s kubectl delete clusterroles --all
#k3s kubectl delete secrets --all

echo Applying dashboard from https://github.com/kubernetes/dashboard/
k3s kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.0.0-rc5/aio/deploy/recommended.yaml

echo Applying service account
k3s kubectl apply -f ./k8s/dashboard-service-account.yml

echo Applying role binding
k3s kubectl apply -f ./k8s/dashboard-clusterrole-binding.yml

echo Getting login token

kubectl -n kubernetes-dashboard describe secret admin-user-token | grep ^token


echo "

======================================================================================================================================

To access Dashboard from your local workstation you must create a secure channel to your Kubernetes cluster. Run the following command:

$ kubectl proxy
Now access Dashboard at:

http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/

Use login token above or re-issue

kubectl -n kubernetes-dashboard describe secret admin-user-token | grep ^token

"
