# NTU-SCTP Cloud Infrastructure Engineering
## Cohort 5 Group 5 Capstone Project<br>
Submitted By: __SOON Leah Foo__<br>
Submitted On: __15 Jun 2024__

## <img src="images/red-3d-ball.png" width="35" /> A. Project Title

## Machine Learning Operations using GitHub Actions with automated deployment to instrumented Kubernetes clusters in a multi-cloud environment.

## <img src="images/orange-3d-ball.png" width="35" /> B. Business Use Case: TraumWare Company Profile

TraumWare Manufacturing Pte Ltd is a Small-Medium Sized company specialising in manufacturing high-precision bolts and nuts for CNC machineries.

In order to ensure the machines are operationally healthy and functioning on a daily basis, the company has to schedule for planned maintenance of the machinery on a regular basis.

The company has more than 20 different makes and models of machineries used in the fabrication process, and it has always been daunting for the company to monitor the status of the various machines. The company approached us for advice and assessment whether there are alternative solutions for a more efficient workflow in terms of optimal forecast plan and efficient usage of available human resources to do the maintenance work.

## <img src="images/yellow-3d-ball.png" width="35" /> C. Project Proposal

Corrective and preventive maintenance is often a major part of manufacturing industries. Although this process is complex and expensive when conducted with conventional approaches, machine learning has now made it easier to discover meaningful insights and hidden patterns in factory data. Because this process helps in reducing risks associated with unexpected failures, companies can also reduce unnecessary expenses by implementing machine learning models. What’s more, artificial intelligence and machine learning algorithms work in collaboration to analyze historical data and ensure workflow visualization.

Here is our proposed solution:

1. We will implement a AI-powered solution to solve the problem. We will automate the machine learning model process so that the resultant trained model can be deployed to the production operating environment without much human intervention.
2.	We will leverage on open-source software and cloud technologies to ensure our solution is scalable and highly available. The trained ML models will be containerised and deployed as RESTAPI endpoints in Kubernetes clusters.
3.	We will deploy the ML model to Kubernetes.
4.	We will put in place an automation process using the GitOps methodology to ensure the ML model version used in the production environment is automatically updated whenever there are new releases of the ML models.
c5.	We will install instrumenting software tools such as Prometheus and ML-Monitor to monitor the health status of the deployed ML model. This is to ensure the ML model maintains its predictive accuracy in the production environment. If the predictive accuracy drops below the acceptable threshold limit, we will trigger the process to retrain the ML model, if necessary.

Here is a summary of the proposed items:

#### _Summary Of Proposed Solution_
Image Source: https://igboie.medium.com/kubernetes-ci-cd-with-github-github-actions-and-argo-cd-36b88b6bda64
<img src="images/c-summary-proposed-solution.png" width="800" />

##
|S/N|Proposed item (Technology stack)           |Description of proposed items|
|---|-------------------------------------------|-----------------------------| 
|c1 |GitHub Actions<br>(CI/CD pipeline)         |GitHub Actions is used to implement a CI/CD pipeline to streamline the MLOps workflow.|
|c2 |Docker/REST API<br>(Containerisation/Microservice)|The ML models created in __(c1)__ are containerised using Docker and published to DockerHub The images are implemented as REST API services using Python/Flask.|
|c3	|Kubernetes<br>(Orchestration platform)     |The services in __(c2)__ are deployed to Elastic Kubernetes Service (EKS) of AWS.<br>EKS is a managed service and thus will handle the auto-scaling, self-healing and auto-provisioning of the required resources for us.|
|c4	|GitOps<br>(CD workflow automation)|The EKS deployment workflow in __(c3)__ is automated and monitored via ArgoCD.<br>Whenever there are updates to the ML model versions and other configurations, ArgoCD will refresh and propagate those changes to the configured environment automatically.|
|c5 |Prometheus/Grafana<br>(Instrumentation)|The services in __(c4)__ are monitored for their reliability by exporting relevant performance metrics from the services using ML Monitor. The metrics are stored in Prometheus and visualised using Grafana.|
|||

## <img src="images/green-3d-ball.png" width="35" /> D. Project Implementation Details

### D1. MLOps CI/CD Pipeline

GitHub Actions has been a very successful automation tool used by software developers to automate the software development life cycle from development stage right through to the deployment stage.

In this project, we will also leverage GitHub Actions as the tool to automate the MLOps workflow.

#### _DevOps CI/CD pipeline (Software Engineering) versus MLOps CI/CD pipeline (Machine Learning)_
<img src="images/d1-devops-cicd-pipeline.png" width="400" /> <img src="images/d1-mlops-cicd-pipeline.png" width="380" />

#### _Different roles involved in MLOps workflow._
<img src="images/d1-mlops-different-roles-involved-in-workflow.png" width="500" />

#### _MLOps workflow using GitHub Actions._
<img src="images/d1-mlops-github-action-workflow-temp.png" width="500" /><br>


In the ML domain, the actual development or the training/fine-tuning of the program codes is usually done by a data scientist. Hence, the Trunk-based development approach (versus the more complex variation using Feature branching) is more suitable as the branching strategy for MLOps workflow.

Reference: https://www.freecodecamp.org/news/what-is-trunk-based-development/

In our MLOps workflow, there are 2 events that will trigger the MLOps pipeline into action:

1.  Pull request from dev branch to main branch.
    -  There will be an approval step for a manager/senior data scientist to check and evaluate the ML model training results, which are stored as GitHub artifacts.
    - Upon approval of the results, the changes and the latest source codes are merged back to the main branch.
    - The model file (one of the files in the GitHub artifacts) is used to build the Docker image.
    - The image is tagged as model-image:latest (i.e. this is a developer build and not to be released to production environment) and is pushed to the DockerHub.
    - If the pull request is not approved for some reasons, the pending CI workflow/job will be cancelled by GitHub Actions and no model-image:latest will be pushed to the DockerHub.

2.  Release event on the main branch with vx.x.x semantic versioned tag.
    - This is a step that requires due diligence on the testing team to schedule the deployment of the release version to the production environment.
    - Upon creation of the release tag, the event will trigger the CD process:
        - Push to DockerHub with 2 images with latest version and vx.x.x.
        - Deploy the infrastructures and the Kubernetes cluster(s) using Terraform.
        - Update the values.yaml file in the application config repository to the new release version vx.x.x.
        - Deployment of the release version vx.x.x of the ML model to the test system is auto-sync via ArgoCD UI or CLI.
        - Deployment of the release version vx.x.x of the ML model to the production system is manually synchronised via ArgoCD UI or CLI.
    - If the release is not approved for some reasons, the pending CD workflow/job will be cancelled by GitHub Actions.

<img src="images/d1-mlops-end-to-end-workflow-temp.png" width="800" />
TO UPDATE THIS FIGURE. KIV

Reference: Engineering MLOps, Emmanuel Raj, Packt Publishing, 2021, pp40.

<XXXdetails><summary><code style="color: yellow">MLOps CI/CD Pipeline Demo</code></summary>

1.  Pre-requisites For MLOps CI/CD Pipeline Demo:

    - Format:
        ```
        kubectl
        ```
2.
```
```

3.
```
```
</details>

### D2. Containerisation <img src="images/docker-logo.png" width="60" /> And Microservices <img src="images/microservices-logo.png" width="60" />

We will containerise the model file created in the preceding step to a Docker image.

Containerisation is one of the cloud-native techologies that we should always exploit, so that our application (i.e. our ML model) is portable, deployable and easily designed for scalability.

In addition to containerising our ML Model, we have also implemented industrial standard protocol using the REST API so that our image can be easily accessed via the HTTP GET and POST method using our internet browser.

<XXXdetails><summary><code style="color: yellow">Containerisation And Microservices Demo</code></summary>

1.  Pre-requisites For Containerisation And Microservices Demo:
    - |S/N|Required software|Version|
      |---|-----------------|-------|
      | 1 | curl            |???|
      | 2 | python          |???|
      | 3 | Postman         |???|
      |||

2.  Use Postman to test the GET method.
 
    <img src="images/d2-containerisation-detail-02-test-get-using-postman.png" width="500" />

3.  Use Postman to test the POST method.

    <img src="images/d2-containerisation-detail-03-test-post-using-postman.png" width="500" />
</details>

### D3. Kubernetes <img src="images/kubernetes-logo.png" width="60" />

We have chosen to use Elastic Kubernetes Service (EKS) which is the managed Kubernetes services of Amazon Web Services' (AWS) as the deployment platform.

EKS is the managed Kubernetes services of Amazon Web Services' (AWS) which offers high-availability, scalability and resilency for our deployed applications.

The EKS is provisioned using Terraform, which is an open-source techology to allow us to deploy infrastructure using codes.

<XXXdetails><summary><code style="color: aqua">Elastic Kubernetes Service (EKS) Deployment Demo</code></summary>

1.  Pre-requisites For EKS Deployment Demo:
    - |S/N|Required software|Version|
      |---|-----------------|-------|
      | 1 | terraform       |v1.8.4 or later.|
      | 2 | kubectl         |???|
      | 3 | AWS account with permission to provision resources.||
      | 4 | AWS credentials setup in local machine.||
      |||

2.  Navigate to the folder terraform/aws and run the `terraform init` command.

    <img src="images/d3-eks-detail-02-terraform-init.png" width="500" />

3.  Run the `terraform apply` command and specify `-var-file=prod.tfvars` as the argument:
    ```
    terraform apply -var-file=prod.tfvars
    ```
    <img src="images/d3-eks-detail-03-terraform-apply-prod.png" width="500" />

    Note that the command will provision the infrastructures (VPC, Network, Firewalls, Internet Gateway, EC2, etc) for the production environment. Please use the dev.tfvars to setup the development/testing environment.
    ```
    terraform apply -var-file=dev.tfvars
    ```
    <img src="images/d3-eks-detail-04-terraform-apply-dev.png" width="500" />
    
4.  Upon prompted by the system, type `yes` and then press the `Enter` key:

    <img src="images/d3-eks-detail-05-terraform-apply-yes.png" width="500" />

5.  Please wait for up to 20 minutes for the Terraform to provision the EKS cluster in AWS.<br>
    Upon completion of the EKS cluster, you should be able to see the information about the cluster:

    <img src="images/d3-eks-detail-06-terraform-apply-output.png" width="500" />

6.  Please note down the details shown in the preceding step because the information is required in section D4 for setting up the
    ArgoCD.

7.  Run the following command to update the kubectl configuration file (Located at ~/.kube/config).<br>
    ```
    kubectl config???
    ```
    <img src="images/d3-eks-detail-07-kubectl-config.png" width="500" />

8.  You are ready to proceed to setup the ArgoCD described in the next section.
</details>

### D4. ArgoCD <img src="images/argocd-logo.png" width="60" />

After deployment of our ML model as an application in the Kubernetes cluster, we make use of ArgoCD to automate the continuous deployment pipeline.

ArgoCD is a declarative GitOps-based continuous deployment tool for Kubernetes. It helps us to deploy and manage applications on Kubernetes clusters in an automated, reliable and repeatable way. It does this by continuously monitoring the live state of the applications in a cluster and compares the state against the desired state defined in the GitHub repository.

Whenever a developer pushes changes to the GitHub repository, ArgoCD will detect the changes and synchronise them to the Kubernetes.

To enable GitOps to work, it is a best practice to have 2 repositories. One for the application source codes and another one for the configuration codes. The configuration codes define the assets in the Kubernetes cluster such as Deployments, Services, ConfigMap, etc. Whenever the configuration codes are updated, ArgoCD will kick in and synchronise the live versus desired states so that they are the same eventually.

However, ArgoCD is only a continuous deployment (CD) tool and we still require a pipeline for continuous integration (CI) that will test and build our application.

<img src="images/d3-argocd-automated-cd-workflow-temp.png" width="800" />

When a developer updates the application source codes, he will test and then build an image which will be pushed to a container repository. The CI pipeline will the trigger updates to the configuration repository (e.g. update the image version) which will cause ArgoCD to synchronise.

GitOps using ArgoCD has these benefits:
- It has the ability to enable Disaster Recovery. In DevOps world, we do not back things up anymore but recreate them instead. If we lose a Kubernetes cluster, we can just bootstrap a new cluster and point the new ArgoCD deployments to the configuration repository. Since everything is defined in codes, ArgoCD will bring up the new cluster to the desired state and we are back in business.
- It has the ability to orchestrate deployments to multiple Kubernetes clusters. ArgoCD is not bound to a single Kubernetes cluster. We can have ArgoCD installed on one cluster controlling the configurations of the other clusters. If any of these clusters were to fail, ArgoCD should be able to bring them back. In addition, if we were to lose the cluster where ArgoCD is installed, it would also be recoverable as the configuration of ArgoCD can be stored as YAML file.
- The applications deployed in the Kubernetes clusters are always synchronised with the single source of truth (i.e. the source GitHub repositories).
- We can adopt security best practice to grant access only to those who are responsible for supporting the CD pipeline.
- We can implement blue/green deployment and/or canary deployment with ease.
- We can always rollback to the previous working version should the new version is not stable.

<XXXdetails><summary><code style="color: cyan">ArgoCD Setup (Using Manifest) Demo</code></summary>

1.  Pre-requisites For ArgoCD Setup (Using Manifest) Demo:
    - |S/N|Required software|Version|
      |---|-----------------|-------|
      | 1 | kubectl         |???|
      | 2 | ArgoCD GUI and CLI tool||
      | 3 | A Kubernetes installed and configured in .kube/config.||
      |||

2.  Run the following command to create the argocd namespace.
    ```
    kubectl create namespace argocd
    ```
    <img src="images/d4-argocd-detail-02-create-namespace.png" width="500" />

3.  Apply the install.yaml manifest file to install ArgoCD.
    ```
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    ```
    <img src="images/d4-argocd-detail-03-apply-install-manifest.png" width="500" />

4.  Use this command to verify the installation.
    ```
    kubectl get all --namespace argocd
    ```
    <img src="images/d4-argocd-detail-04-verify-installation.png" width="500" />

    Please wait for few minutes for all the pods to be ready in Running status. These are all the components that are required for ArgoCD to function properly.

5.  We can access ArgoCD via its Graphical User Interface (GUI). But we need to use a mechanism
    called “port-forwarding” on the service called service/argocd-server (which is listening on
    port 80 and 443). By-pass the certificate check, if necessary.
    ```
    kubectl get services -n argocd
    kubectl port-forward service/argocd-server --namespace argocd 8080:443
    ```
    <img src="images/d4-argocd-detail-05-port-forwarding.png" width="500" />

6.  Run the following command to get the initial password of ArgoCD. You will need it to login
    to the ArgoCD GUI.
    ```
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
    ```
    <img src="images/d4-argocd-detail-06-decode-initial-password.png" width="500" />

7.  Go to the browser and enter the following address as the URL to access the ArgoCD GUI.
    ```
    http://localhost:8080
    ```
8.  When the ArgoCD GUI is up, enter __admin__ as the __Username__. For the __Password__, enter
    the text that you obtained in step 6.

    <img src="images/d4-argocd-detail-07-argocd-gui.png" width="500" />

9.  Within the ArgoCD GUI, click Create Application. Please enter the following details:
    Application name: XXX
    Project: default
    __Create namespace__: Tick this option
    Repo URL: XXX
    Target server: XXX

    Then click the Create button at the bottom of the screen.

    <img src="images/d4-argocd-detail-08-create-application.png" width="500" />

10. Please wait for the application to show healthy status (i.e. Synchronised/Healthy).

    <img src="images/d4-argocd-detail-08-show-application.png" width="500" />

11. Repeat step 9 and 10 to create a second application, if required.

![alt text](image.png)
</details>

### D5. Prometheus <img src="images/prometheus-logo.png" width="60" /> And Grafana

Although Kubernetes has self-healing capability, it is not desirable if there are indeed outages in the deployed application.

Very often, we will want to monitor the ML model not only for its performance, latency and predictive accuracy, we also want to perform health check on the operating environment to give insights on whether the operating environment is working as per our expectation.

In the program codes that we used for training the ML model, we have also implemented instrumentation capability to make the model itself export relevant ML-related metrics (such as data and model drift, prediction accuracy, classification and regression metrics, etc). These metrics can then be configured in the instrumentation software for us to analyse the data for performance, operation, troubleshooting and optimisation purpose.

#### _ML Monitoring_
Image Source: https://bowtiedraptor.substack.com/p/mlops-18-monitoring-with-prometheus
<img src="images/d5-prometheus-ml-monitoring.png" width="800" />

#### _ML Monitoring With Prometheus And Grafana_
Image Source: https://bowtiedraptor.substack.com/p/mlops-18-monitoring-with-prometheus
<img src="images/d5-prometheus-ml-monitoring-with-prometheus-and-grafana.png" width="800" />

<XXXdetails><summary><code style="color: yellow">Prometheus And Grafana Setup Demo</code></summary>

1.  Pre-requisites For Prometheus And Grafana Setup Demo:
    - |S/N|Required software|Version|
      |---|-----------------|-------|
      | 1 | helm            |vXXXX or later.|
      | 2 | kubectl         |???|
      | 3 | A Kubernetes installed and configured in .kube/config.||
      |||

2.  Go to https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus and locate the
    prometheus chart.

    <img src="images/d5-prometheus-detail-02-select-prometheus.png" width="500" />

3.  Run the following command to add the prometheus chart to the Helm repository.
    ```
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    ```
    <img src="images/d5-prometheus-detail-03-add-prometheus-to-helm.png" width="500" />

4.  Update the Helm repository with this command.
    ```
    helm repo update
    ```
    <img src="images/d5-prometheus-detail-04-update-helm.png" width="500" />

5.  Install Prometheus using this command.
    ```
    kubectl install prometheus prometheus-community/prometheus
    ```
    <img src="images/d5-prometheus-detail-05-install-prometheus.png" width="500" />

6.  Verify the installation.
    ```
    kubectl get pods
    ```
    <img src="images/d5-prometheus-detail-06-verify-installation.png" width="500" />

    Please wait for few minutes for all the pods to be ready in Running status. These are all the components that are required for Prometheus to function properly.

7.  In order to access Prometheus from outside the cluster, we need to expose the node port.
    ```
    kubectl get services <<< NEED TO ADD NAMESPACE???
    kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-ext
    ```
    <img src="images/d5-prometheus-detail-07-expose-prometheus-server.png" width="500" />

    You will see there is one extra service (with the name of prometheus-server-ext) created.

8.  Go to the browser and enter `xxx` as the URL. The port is the 5-digit number associated with the newly created
    service prometheus-server-ext.

    <img src="images/d5-prometheus-detail-08-prometheus-gui.png" width="500" />

9.  Within Prometheus GUI, go to Status/Targets...

    <img src="images/d5-prometheus-detail-09-prometheus-gui-target-status.png" width="500" />

    <img src="images/d5-prometheus-detail-10-prometheus-gui-target-status-details.png" width="500" />

    <img src="images/d5-prometheus-detail-10-prometheus-gui-metrics.png" width="500" />

10. To install Grafana, run the following command:
    ```
    kubectl get pods
    ```
    <img src="images/d5-prometheus-detail-06-verify-installation.png" width="500" />

11. XXX:
    ```
    XXX
    ```
    <img src="images/d5-prometheus-detail-06-verify-installation.png" width="500" />

12. XXX:
    ```
    XXX
    ```
    <img src="images/d5-prometheus-detail-06-verify-installation.png" width="500" />

13. XXX:
    ```
    XXX
    ```
    <img src="images/d5-prometheus-detail-06-verify-installation.png" width="500" />

14. XXX:
    ```
    XXX
    ```
    <img src="images/d5-prometheus-detail-06-verify-installation.png" width="500" />

15. XXX:
    ```
    XXX
    ```
    <img src="images/d5-prometheus-detail-06-verify-installation.png" width="500" />

16. XXX:
    ```
    XXX
    ```
    <img src="images/d5-prometheus-detail-06-verify-installation.png" width="500" />
</details>

## <img src="images/blue-3d-ball.png" width="35" /> E. Project Summary

## <img src="images/indigo-3d-ball.png" width="35" /> F. Suggestions For Future Work

## <img src="images/violet-3d-ball.png" width="35" /> G. References
