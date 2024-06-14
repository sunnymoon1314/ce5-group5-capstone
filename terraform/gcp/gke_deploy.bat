@ECHO OFF
REM Update the %USERPFOFILE%\.kube\config file to include an entry for the newly created GKE cluster.
gcloud container clusters get-credentials gke-cluster-prod --region us-central1 --project enhanced-option-423814-n0

REM Set gke-cluster-prod as the current-context.
kubectl config use-context gke-cluster-prod

REM Deploy the Kubernetes resources to the prod namespace of the GKE cluster.
%USERPFOFILE%\build.bat prod
