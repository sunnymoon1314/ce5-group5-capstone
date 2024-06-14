@ECHO OFF
REM Update the %USERPFOFILE%\.kube\config file to include an entry for the newly created AKS cluster.
az aks get-credentials --resource-group aks-resource-group-rg --name aks-cluster-prod

REM Set aks-cluster-prod as the current-context.
kubectl config use-context aks-cluster-prod

REM Deploy the Kubernetes resources to the prod namespace of the AKS cluster.
%USERPFOFILE%\build.bat prod
