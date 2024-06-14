@ECHO OFF
REM Update the %USERPFOFILE%\.kube\config file to include an entry for the newly created EKS cluster.
aws eks update-kubeconfig --region us-east-1 --name eks-cluster-prod

REM Set eks-cluster-prod as the current-context.
kubectl config use-context eks-cluster-prod

REM Deploy the Kubernetes resources to the prod namespace of the EKS cluster.
%USERPFOFILE%\build.bat prod
