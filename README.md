# NTU-SCTP Cloud Infrastructure Engineering
## Cohort 5 Group 5 Capstone Project<br>
Submitted By: __SOON Leah Foo__<br>
Submitted On: __15 Jun 2024__

## <img src="images/3d-ball-icon/red-3d-ball.png" width="35" /> A. Project Title

## Machine Learning Operations using GitHub Actions with automated deployment to Kubernetes clusters.

## <img src="images/3d-ball-icon/orange-3d-ball.png" width="35" /> B. Business Use Case

Data Driven Cloud Consultancy Services is a company that specialises in providing customised AI-powered cloud solutions to its clients.

We have been approached by one of our prospective client which is a small-medium-sized company specialising in producting paper boxes in their factories.

In order to ensure the machines are operationally healthy and functioning on a daily basis, the company has to schedule for planned maintenance of the machinery on a regular basis.

The company has more than 20 different makes and models of machineries used in the fabrication process, and it has always been daunting for the company to monitor the operational status of the various machines, to ensure there is minimal downtime due to breakdown and faults in the machines.

The company thus approached us for professional advice and assessment whether there are cost-effective ways to schedule for preventive maintenance and to reduce any impact caused by machine breakdown.

## <img src="images/3d-ball-icon/yellow-3d-ball.png" width="35" /> C. Project Proposal

Corrective and preventive maintenance is often a major part of manufacturing industries. Although this process is complex and expensive when conducted with conventional approaches, machine learning has now made it easier to discover meaningful insights and hidden patterns in factory data.

Because this process helps in reducing risks associated with unexpected failures, companies can also reduce unnecessary expenses by implementing machine learning models (ML models). What’s more, artificial intelligence and machine learning algorithms work in collaboration to analyze historical data and ensure workflow visualization.

Below is a summary of our proposal:

1.  We will conduct on-site survey of their factories and assessed the position(s) on each of the machines where sensors/IoT devices can be attached to capture data on temperature, sound, humidity, rotation speed, and other statistics that can help to detect fault in the machine.

2.  These sensor data will be collected and uploaded to the cloud and stored in AWS S3 bucket.

3.  The data in S3 will be cleaned and pre-processecd to remove any invalid data.

4.  We will load the data in the S3 buckets to train and build a ML model which is able to predict whether the machine that produced the data is about to fail or require any attention for corrective maintenance.

5.  The trained ML models will be containerised and deployed as RESTAPI endpoints to Kubernetes clusters.

6.  We will automate the deployment process to ensure the ML model in the production environment can be easily updated whenever there are new releases of the ML models.

Here is a summary of the proposed items:

### _Summary Of Proposed Solution_
Image Source: https://igboie.medium.com/kubernetes-ci-cd-with-github-github-actions-and-argo-cd-36b88b6bda64

<img src="images/c-summary-proposed-solution.png" width="600" />

##
|S/N|Proposed item<br>(Technology stack) |Description of proposed items|
|---|------------------------------------|-----------------------------| 
|c1 |GitHub Actions<br>(CI pipeline)  |GitHub Actions is used to implement a CI pipeline to create the ML model.|
|c2 |Docker/REST API<br>(Containerisation/Microservice)|The ML models created in __(c1)__ are containerised using Docker and published to DockerHub. The images are implemented as REST API services using Python/Flask.|
|c3	|Kubernetes<br>(Orchestration platform)     |The services in __(c2)__ are deployed to Elastic Kubernetes Service (EKS) of AWS using Terraform.<br>EKS is a managed service and thus will handle the auto-scaling, self-healing and auto-provisioning of the required resources for us.|
|c4	|ArgoCD<br>(CD workflow automation)|The configurations of EKS deployed in __(c3)__ is stored in a config repository.<br>ArgoCD is setup to monitor if there are changes to this config repository. Wnenever it detects any updates to the ML model versions and/or other settings such as number of replicas, new services added, etc, ArgoCD will refresh and propagate those changes to the Kubernetes cluster(s) automatically.|
|||

## <img src="images/3d-ball-icon/green-3d-ball.png" width="35" /> D. Project Implementation Details

### D1. MLOps CI/CD Pipeline

GitHub Actions has been a very successful automation tool used by software developers to automate the software development life cycle from development stage right through to the deployment stage.

In this project, we will also leverage GitHub Actions as the tool to automate the MLOps workflow.

#### _DevOps CI/CD pipeline (Software Engineering) versus MLOps CI/CD pipeline (Machine Learning)_
<img src="images/d1-devops-cicd-pipeline.png" width="400" /> <img src="images/d1-mlops-cicd-pipeline.png" width="380" />

#### _Different roles involved in MLOps workflow._
<img src="images/d1-mlops-different-roles-involved-in-workflow.png" width="600" />

#### _MLOps workflow using GitHub Actions._
<img src="images/d1-mlops-github-action-workflow.png" width="600" /><br>

In the ML domain, the actual development or the training/fine-tuning of the program codes is usually done by a data scientist. Hence, the Trunk-based development approach (versus the more complex variation using Feature branching) is more suitable as the branching strategy for MLOps workflow.

Reference: https://www.freecodecamp.org/news/what-is-trunk-based-development/

In our MLOps workflow, there are mainly 3 events that will trigger the MLOps pipeline into action:

1.  __Push event at dev branch__

    -  The trained ML model as well as training results will saved as GitHub artifacts for audit trail purpose.

2.  __Pull request from dev branch to main branch__

    -   New pull requests to merge changes from dev to the main branch are subjected to approval by a manager/senior data scientist to validate and assess the ML model training results, which are available as GitHub artifacts.
    -   Upon acceptance of the test results and approval of the pull request, the changes and the latest source codes are merged back to the main branch.
    -   The ML model file (one of the files in the GitHub artifacts) will be used to build the Docker image and tagged as ml-model:latest (note that this is a developer build and not to be released to production environment) and is pushed to the DockerHub.
    -   If the pull request is rejected for some reasons, the pending CI workflow/job will be cancelled by GitHub Actions and no ml-model:latest will be pushed to the DockerHub.

3.  __Release event on the main branch with vx.x.x semantic version tag__

    -   This is a step that requires due diligence on the testing/QA team to schedule the deployment of the release version of the ML model to the production environment.
    -   Upon creation of the release tag, the event will trigger the CD process:
        -   Push to DockerHub with 2 images with respective tag of latest and vx.x.x.
        -   Update the values.yaml file in the application config repository to the new release version vx.x.x.
        -   Deployment of the release version vx.x.x of the ML model to the test/dev system is auto-sync via ArgoCD UI or CLI.
        -   Deployment of the release version vx.x.x of the ML model to the production system is manually synchronised via ArgoCD UI or CLI.
    -   If the release is rejected for some reasons, the pending CD workflow/job will be cancelled by GitHub Actions.

<details><summary><code style="color: yellow">MLOps CI/CD Pipeline Event Details</code></summary>

1.  __Push event at dev branch__

    -   `git push` at the command prompt window:

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-02-git-push-dev.png" width="600" />

    -   train-build.yml workflow running in progress...

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-03-train-build-running.png" width="600" />

    -   train-build.yml workflow completed.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-04-train-build-completed.png" width="600" />

    -   The artifact files can be downloaded by clicking the download button on the right of the file name.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-05-artifact-zip-file.png" width="600" /><br>

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-06-artifact-contents.png" width="600" />

2.  __Pull request from dev branch to main branch__

    -   Create a pull request in the GitHub Graphical User Interface (GUI) by clicking on the __New pull request__ button.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-07-create-pull-request.png" width="600" />

    -   Select dev from the Compare list.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-08-select-compare-dev.png" width="600" />

    -   The changes made in the dev branch will be listed for your reference. Click the __Create pull request__ to effect the creation.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-09-changes-in-dev.png" width="600" />

    -   Add a description for the changes made and click the __Create pull request__ button at the bottom of the screen.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-10-pull-request-description.png" width="600" />

    -   The list of pending pull request(s) will be listed in the Pull requests tab.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-11-pull-request-pending.png" width="600" />

    -   The requestor will select the pull request to submit for approval, by clicking on the name of the branch name next to the checkbox.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-12-pull-request-selected.png" width="600" />

    -   Within the pull request page, scroll to the bottom of the screen and add a comment, if any.
        And then click the __Merge pull request__ button.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-13-pull-request-submit-for-approval.png" width="600" />

    -   And then click the __Confirm merge__ button.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-14-pull-request-confirm-merge.png" width="600" />

    -   If there are no conflicts to be resolved, the merger should be successful.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-15-pull-request-merged-and-closed.png" width="600" />

    -   The manager or the seniors will receive a notification of the pull request via email.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-16-pull-request-email.png" width="600" />

    -   Within the notification email, click the Review pending deployments.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-17-pull-request-review-pending-deployments.png" width="600" />

    -   In the approval screen, notice the build-and-push-image-to-docker-hub job is waiting for review. If necessary, the artifacts are also available at the bottom of the screen for validation.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-18-pull-request-review-deployments.png" width="600" />

    -   Once the artifacts are checked and all in order, Click __Review deployments__ and on the next screen, tick the prod checkbox and then click the __Approve and deploy__ button.

    -   The ml-model:latest image is now pushed to the DockerHub upon approval.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-19-pull-request-approved.png" width="600" /><br>

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-20-build-and-push-image-to-docker-hub-completed.png" width="600" />

    -   Open the Docker Desktop and check that the ml-model:latest is now pushed to the DockerHub.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-21-ml-model-pushed-to-dockerhub.png" width="600" />

3.  __Release event on the main branch with vx.x.x semantic version tag__

    -   To create a new tag, use the `git tag` command and specify the tag name that you want to create.
        ```
        git tag <tag_name>
        ```
        For example, if you want to create a new tag v1.0.0 as the new release version, then type:
        ```
        git tag v1.0.0
        ```
    -   Use the `git tag` command again without specifying the <tag_name> to list the existing tags available in the repository.
        ```
        git tag

        v1.0.0
        ```
        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-25-create-release-tag.png" width="600" />

    -   Use the following command to update the tag in the remote repository.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-26-update-remote-repository.png" width="600" />

    -   Go to the GitHub GUI __Code__ tab and dlick on the __Tags__ icon.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-27-github-gui-code-tab.png" width="600" /><br>

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-28-select-tag-icon.png" width="600" />

    -   You will see the list of tags available in the repository.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-29-available-tag-list.png" width="600" />

    -   Click the __Tag__ you want to use as the release version.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-30-selected-tag.png" width="600" />

    -   Click __Create release from tag__ located on the top-right of the screen.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-31-create-release-from-tag.png" width="600" />

    -   Scroll to the bottom of the screen and click the __Publish release__ button.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-32-publish-release.png" width="600" />

    -   After the __Publish release__ button is pressed, review and approve the deployment to production.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-33-release-review-pending-deployments.png" width="600" />

    -   The deploy.yml will run and update the DockerHub with new images (the existing latest tag as well as the v1.0.0).

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-34-release-review-pending-deployments.png" width="600" />

    -   Deploy workflow in action...

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-35-ml-model-deploy_workflow-running.png" width="600" />

    -   Open the Docker Desktop and check that the ml-model:latest and ml-model:v1.0.0 are now pushed to the DockerHub.

        <img src="images/d1-mlops-workflow-detail/d1-mlops-workflow-detail-36-ml-model-pushed-release-version-to-dockerhub.png" width="600" />

Reference(s):
-   [How to Create a Tag in a GitHub Repository: A Step-by-Step Guide](https://git.wtf/how-to-create-a-tag-in-a-github-repository-a-comprehensive-guide/).
-   [How To Create Git Tags](https://devconnected.com/how-to-create-git-tags/).
</details>

### D2. Containerisation <img src="images/logo/d2-docker-logo.png" width="60" /> And Microservices <img src="images/logo/d2-microservices-logo.png" width="60" />

We will containerise the model file created in the preceding step to a Docker image.

Containerisation is one of the cloud-native techologies that we should always exploit, so that our application (i.e. our ML model) is portable, deployable and easily designed for scalability.

In addition to containerising our ML Model, we have also implemented industrial standard protocol using the REST API so that our image can be easily accessed via the HTTP GET and POST method using our internet browser.

<details><summary><code style="color: yellow">Containerisation And Microservices Testing Instructions</code></summary>

1.  Pre-requisites For Containerisation And Microservices Testing Instructions:
    - |S/N|Required software|Version|
      |---|-----------------|-------|
      | 1 | Postman sign-in account||
      |||

2.  Use Postman to test the GET method.

    <img src="images/d2-containerisation-detail-02-test-get-using-postman.png" width="600" />

3.  Use Postman to test the POST method.

    <img src="images/d2-containerisation-detail-03-test-post-using-postman.png" width="600" />
</details>

### D3. Kubernetes <img src="images/logo/d3-kubernetes-logo.png" width="60" />

We have chosen to use Elastic Kubernetes Service (EKS) which is the managed Kubernetes services of Amazon Web Services' (AWS) as the deployment platform.

EKS is the managed Kubernetes services of Amazon Web Services' (AWS) which offers high-availability, scalability and resilency for our deployed applications.

The EKS is provisioned using Terraform, which is an open-source techology to allow us to deploy infrastructure using codes.

<XXXdetails><summary><code style="color: aqua">Elastic Kubernetes Service (EKS) Deployment Instructions</code></summary>
1.  Pre-requisites For EKS Deployment Instructions:
    - |S/N|Required software|Version|
      |---|-----------------|-------|
      | 1 | terraform       |v1.8.5 or later.|
      | 2 | kubectl         |???|
      | 3 | AWS account with permission to provision resources.||
      | 4 | AWS credentials setup in local machine.||
      |||

2.  Navigate to the folder terraform/aws:

    <img src="images/d3-eks-detail/d3-eks-detail-02-terraform-aws-folder-structure.png" width="600" />

3.  Run the `terraform init` command to initialise and download any plugins.

    <img src="images/d3-eks-detail/d3-eks-detail-03-terraform-init.png" width="600" />

4.  Run the `terraform apply` command with the argument `-var-file=prod.tfvars` and press the `Enter` key.
    ```
    terraform apply -var-file=prod.tfvars
    ```
    <img src="images/d3-eks-detail/d3-eks-detail-04-terraform-apply-prod.png" width="600" />

    Note that the command will provision the infrastructures (VPC, Network, Firewalls, Internet Gateway, EC2, etc) for the production environment. Please use the dev.tfvars to setup the development/testing environment, if required, in a separate run.
    ```
    terraform apply -var-file=dev.tfvars
    ```

5.  Upon prompted by the system, type `yes` and then press the `Enter` key:

    <img src="images/d3-eks-detail/d3-eks-detail-05-terraform-apply-yes.png" width="600" />

6.  Please wait for up to 20 minutes for the Terraform to provision the EKS cluster in AWS.

    <img src="images/d3-eks-detail/d3-eks-detail-06-terraform-apply-running.png" width="600" />

7.  Upon completion of the EKS cluster, you should be able to see the information about the cluster:

    <img src="images/d3-eks-detail/d3-eks-detail-07-terraform-apply-output.png" width="600" />

8.  Please note down the details shown in the preceding step because the information is required in section D4 for installing the ArgoCD.

9.  After the cluster is created successfully, you need to configure your local machine to access to it.
    For EKS, the command is:
    ```
    aws eks update-kubeconfig --region <REGION-CODE> --name <CLUSTER_NAME>
    ```
    ```
    Outputs:

    eks_cluster_endpoint = "https://0B7D242CD8556B4E1F622308C953BCE8.gr7.us-east-1.eks.amazonaws.com"
    eks_cluster_name = "eks-cluster-dev" <<<<<< Need this for next step.
    eks_cluster_region = "us-east-1" <<<<<< Need this for next step.
    eks_cluster_security_group_id = "sg-0d91e4c82b2a10693"
    eks_cluster_version = "1.29"
    kubeconfig_command = "aws eks update-kubeconfig --region us-east-1 --name eks-cluster-dev"
    ```

10. Run the following command to update the kubectl configuration file (Located at ~/.kube/config), so that your local machine is configured to access the newly created EKS cluster.
    ```
    aws eks update-kubeconfig --region us-east-1 --name eks-cluster-dev
    ```
    <img src="images/d3-eks-detail/d3-eks-detail-08-update-kubeconfig.png" width="600" />

11. Run some commands using kubectl to verify you are able to access the cluster.
    ```
    kubectl get namespaces
    kubectl get pods --all-namespaces
    kubectl cluster-info
    ```
    <img src="images/d3-eks-detail/d3-eks-detail-09-kubectl-test-commands.png" width="600" /><br>

    <img src="images/d3-eks-detail/d3-eks-detail-10-kubectl-cluster-info.png" width="600" />

12. You are ready to proceed to setup the ArgoCD described in the next section.

13. Please remember to delete the resources that you deployed in the preceding steps if the resources are no longer required:
    ```
    terraform destroy -var-file=prod.tfvars
    ```
    <img src="images/d3-eks-detail/d3-eks-detail-11-terraform-destroy-yes.png" width="600" /><br>

    <img src="images/d3-eks-detail/d3-eks-detail-12-terraform-destroy-completed.png" width="600" />
</details>

<XXXdetails><summary><code style="color: aqua">Azure Kubernetes Service (AKS) Deployment Instructions</code></summary>
1.  Pre-requisites For AKS Deployment Instructions:
    - |S/N|Required software|Version|
      |---|-----------------|-------|
      | 1 | terraform       |v1.8.5 or later.|
      | 2 | kubectl         |???|
      | 3 | Azure account with permission to provision resources.||
      | 4 | Azure credentials setup in local machine.||
      |||

2.  Navigate to the folder terraform/aze:

    <img src="images/d3-aks-detail/d3-aks-detail-02-terraform-aze-folder-structure.png" width="600" />

3.  Run the `terraform init` command to initialise and download any plugins.

    <img src="images/d3-aks-detail/d3-aks-detail-03-terraform-init.png" width="600" />

4.  Run the `terraform apply` command with the argument `-var-file=prod.tfvars` and press the `Enter` key.
    ```
    terraform apply -var-file=prod.tfvars
    ```
    <img src="images/d3-aks-detail/d3-aks-detail-04-terraform-apply-prod.png" width="600" />

    Note that the command will provision the infrastructures (VNet, Network, Firewalls, Internet Gateway, VMs, etc) for the production environment. Please use the dev.tfvars to setup the development/testing environment, if required, in a separate run.
    ```
    terraform apply -var-file=dev.tfvars
    ```

5.  Upon prompted by the system, type `yes` and then press the `Enter` key:

    <img src="images/d3-aks-detail/d3-aks-detail-05-terraform-apply-yes.png" width="600" />

6.  Please wait for up to 20 minutes for the Terraform to provision the EKS cluster in AWS.

    <img src="images/d3-aks-detail/d3-aks-detail-06-terraform-apply-running.png" width="600" />

7.  Upon completion of the AKS cluster, you should be able to see the information about the cluster:

    <img src="images/d3-aks-detail/d3-aks-detail-07-terraform-apply-output-dev.png" width="600" />

8.  Please note down the details shown in the preceding step because the information is required in section D4 for installing the ArgoCD.

9.  After the cluster is created successfully, you need to configure your local machine to access to it.
    For AKS, the command is:
    ```
    az aks get-credentials --resource-group <RESOURCE-GROUP> --name <CLUSTER_NAME>
    ```
    ```
    Outputs:

    aks_cluster_location = "westus2"
    aks_cluster_name = "aks-cluster-dev" <<<<<< Need this for next step.
    aks_cluster_resource_group_name = "aks-resource-group-rg" a<<<<<< Need this for next step.dsasd
    aks_cluster_version = "1.29"
    kubeconfig_command = "az aks get-credentials --resource-group aks-resource-group-rg --name aks-cluster-dev"
    ```

10. Run the following command to update the kubectl configuration file (Located at ~/.kube/config), so that your local machine is configured to access the newly created EKS cluster.
    ```
    az aks get-credentials --resource-group aks-resource-group-rg --name aks-cluster-dev
    ```
    <img src="images/d3-aks-detail/d3-aks-detail-08-update-kubeconfig-prod.png" width="600" />

11. Run some commands using kubectl to verify you are able to access the cluster.
    ```
    kubectl get namespaces
    kubectl get pods --all-namespaces
    kubectl cluster-info
    ```
    <img src="images/d3-aks-detail/d3-aks-detail-09-kubectl-test-commands.png" width="600" /><br>

    <img src="images/d3-aks-detail/d3-aks-detail-10-kubectl-cluster-info.png" width="600" />

12. You are ready to proceed to setup the ArgoCD described in the next section.

13. Please remember to delete the resources that you deployed in the preceding steps if the resources are no longer required:
    ```
    terraform destroy -var-file=prod.tfvars
    ```
    <img src="images/d3-aks-detail/d3-aks-detail-11-terraform-destroy-yes.png" width="600" /><br>

    <img src="images/d3-aks-detail/d3-aks-detail-12-terraform-destroy-completed.png" width="600" />
</details>

<XXXdetails><summary><code style="color: aqua">Google Kubernetes Engine (GKE) Deployment Instructions</code></summary>
1.  Pre-requisites For GKE Deployment Instructions:
    - |S/N|Required software|Version|
      |---|-----------------|-------|
      | 1 | terraform       |v1.8.5 or later.|
      | 2 | kubectl         |???|
      | 3 | Google cloud account with permission to provision resources.||
      | 4 | Google cloud credentials setup in local machine.||
      |||

2.  Navigate to the folder terraform/gcp:

    <img src="images/d3-gke-detail/d3-gke-detail-02-terraform-gcp-folder-structure.png" width="600" />

3.  Run the `terraform init` command to initialise and download any plugins.

    <img src="images/d3-gke-detail/d3-gke-detail-03-terraform-init.png" width="600" />

4.  Run the `terraform apply` command with the argument `-var-file=prod.tfvars` and press the `Enter` key.
    ```
    terraform apply -var-file=prod.tfvars
    ```
    <img src="images/d3-gke-detail/d3-gke-detail-04-terraform-apply-prod.png" width="600" />

    Note that the command will provision the infrastructures (VNet, Network, Firewalls, Internet Gateway, VMs, etc) for the production environment. Please use the dev.tfvars to setup the development/testing environment, if required, in a separate run.
    ```
    terraform apply -var-file=dev.tfvars
    ```

5.  Upon prompted by the system, type `yes` and then press the `Enter` key:

    <img src="images/d3-gke-detail/d3-gke-detail-05-terraform-apply-yes.png" width="600" />

6.  Please wait for up to 20 minutes for the Terraform to provision the EKS cluster in AWS.

    <img src="images/d3-gke-detail/d3-gke-detail-06-terraform-apply-running.png" width="600" />

7.  Upon completion of the AKS cluster, you should be able to see the information about the cluster:

    <img src="images/d3-gke-detail/d3-gke-detail-07-terraform-apply-output.png" width="600" />

8.  Please note down the details shown in the preceding step because the information is required in section D4 for installing the ArgoCD.

9.  After the cluster is created successfully, you need to configure your local machine to access to it.
    For GKE, the command is:
    ```
    gcloud container clusters get-credentials <CLUSTER_NAME> --region <REGION-CODE> --project <PROJECT_ID>
    ```
    ```
    Outputs:

    gke_cluster_endpoint = "34.41.145.139"
    gke_cluster_master_version = "1.29.5-gke.1091000"
    gke_cluster_name = "gke-cluster-prod"
    gke_cluster_region = "us-central1"
    gke_cluster_regional = true
    gke_cluster_zones = tolist([
        "us-central1-b",
        "us-central1-c",
        "us-central1-f",
    ])
    kubeconfig_command = "gcloud container clusters get-credentials gke-cluster-prod --region us-central1-a --project enhanced-option-423814-n0"
    ```
    ```
    Outputs:

    gke_cluster_endpoint = "34.138.134.79"
    gke_cluster_master_version = "1.29.5-gke.1091000"
    gke_cluster_name = "gke-cluster-dev" <<<<<< Need this for next step.
    gke_cluster_region = "us-east1" <<<<<< Need this for next step.
    gke_cluster_regional = false
    gke_cluster_zones = tolist([])
    kubeconfig_command = "gcloud container clusters get-credentials gke-cluster-dev --region us-east1-b --project enhanced-option-423814-n0"
    ```

10. Run the following command to update the kubectl configuration file (Located at ~/.kube/config), so that your local machine is configured to access the newly created GKE cluster.
    ```
    gcloud container clusters get-credentials gke-cluster-prod --region us-central1 --project enhanced-option-423814-n0
    ```
    <img src="images/d3-gke-detail/d3-gke-detail-08-update-kubeconfig-prod.png" width="600" /><br>

    ```
    gcloud container clusters get-credentials gke-cluster-dev --region us-east1-b --project enhanced-option-423814-n0
    ```
    <img src="images/d3-gke-detail/d3-gke-detail-08-update-kubeconfig-dev.png" width="600" />

11. Run some commands using kubectl to verify you are able to access the cluster.
    ```
    kubectl get namespaces
    kubectl get pods --all-namespaces
    kubectl cluster-info
    ```
    <img src="images/d3-gke-detail/d3-gke-detail-09-kubectl-test-commands.png" width="600" /><br>

    <img src="images/d3-gke-detail/d3-gke-detail-10-kubectl-cluster-info.png" width="600" />

12. You are ready to proceed to setup the ArgoCD described in the next section.

13. Please remember to delete the resources that you deployed in the preceding steps if the resources are no longer required:
    ```
    terraform destroy -var-file=prod.tfvars
    ```
    <img src="images/d3-gke-detail/d3-gke-detail-11-terraform-destroy-yes.png" width="600" /><br>

    <img src="images/d3-gke-detail/d3-gke-detail-12-terraform-destroy-completed.png" width="600" />
</details>

### D4. ArgoCD <img src="images/logo/d4-argocd-logo.png" width="60" />

After deployment of our ML model as an application in the Kubernetes cluster, we make use of ArgoCD to automate the continuous deployment pipeline.

ArgoCD is a declarative GitOps-based continuous deployment tool for Kubernetes. It helps us to deploy and manage applications on Kubernetes clusters in an automated, reliable and repeatable way. It does this by continuously monitoring the live state of the applications in a cluster and compares the state against the desired state defined in the GitHub repository.

Whenever a developer pushes changes to the GitHub repository, ArgoCD will detect the changes and synchronise them to the Kubernetes.

To enable GitOps to work, it is a best practice to have 2 repositories. One for the application source codes and another one for the configuration codes. The configuration codes define the assets in the Kubernetes cluster such as Deployments, Services, ConfigMap, etc. Whenever the configuration codes are updated, ArgoCD will kick in and synchronise the live versus desired states so that they are the same eventually.

However, ArgoCD is only a continuous deployment (CD) tool and we still require a pipeline for continuous integration (CI) that will test and build our application.

<img src="images/d4-argocd-automated-cd-workflow-temp.png" width="600" />

When a developer updates the application source codes, he will test and then build an image which will be pushed to a container repository. The CI pipeline will the trigger updates to the configuration repository (e.g. update the image version) which will cause ArgoCD to synchronise.

GitOps using ArgoCD has these benefits:
- It has the ability to enable Disaster Recovery. In DevOps world, we do not back things up anymore but recreate them instead. If we lose a Kubernetes cluster, we can just bootstrap a new cluster and point the new ArgoCD deployments to the configuration repository. Since everything is defined in codes, ArgoCD will bring up the new cluster to the desired state and we are back in business.
- It has the ability to orchestrate deployments to multiple Kubernetes clusters. ArgoCD is not bound to a single Kubernetes cluster. We can have ArgoCD installed on one cluster controlling the configurations of the other clusters. If any of these clusters were to fail, ArgoCD should be able to bring them back. In addition, if we were to lose the cluster where ArgoCD is installed, it would also be recoverable as the configuration of ArgoCD can be stored as YAML file.
- The applications deployed in the Kubernetes clusters are always synchronised with the single source of truth (i.e. the source GitHub repositories).
- We can adopt security best practice to grant access only to those who are responsible for supporting the CD pipeline.
- We can implement blue/green deployment and/or canary deployment with ease.
- We can always rollback to the previous working version should the new version is not stable.

<XXXdetails><summary><code style="color: green">ArgoCD Installation (Using Manifest) Instructions</code></summary>

1.  Pre-requisites For ArgoCD Installation (Using Manifest) Instructions:
    - |S/N|Required software|Version|
      |---|-----------------|-------|
      | 1 | kubectl         |???|
      | 2 | kustomize       |???|
      | 3 | A Kubernetes cluster installed and configured in .kube/config.||
      |||

2.  Run the following command to create the argocd namespace.
    ```
    kubectl create namespace argocd
    ```
    <img src="images/d4-argocd-detail/d4-argocd-detail-02-create-namespace.png" width="600" />

3.  Apply the install.yaml manifest file to install ArgoCD.
    ```
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    ```
    <img src="images/d4-argocd-detail/d4-argocd-detail-03-install-argocd.png" width="600" /><br>

    <img src="images/d4-argocd-detail/d4-argocd-detail-04-install-argocd-2.png" width="600" />

4.  Apply the install.yaml manifest file to install ArgoCD Image Updater.
    ```
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml
    ```
    <img src="images/d4-argocd-detail/d4-argocd-detail-05-install-argocd-image-updater.png" width="600" /><br>

5.  Use this command to verify the ArgoCD installation.
    ```
    kubectl get all --namespace argocd
    ```
    <img src="images/d4-argocd-detail/d4-argocd-detail-06-verify-installation.png" width="600" />

    Search for ArgoCD. It is argocd. And for the Image Updater, it is argocd-image-updater.

    Quite a lot of components are required for ArgoCD to function properly.

6. We can access ArgoCD via its Graphical User Interface (GUI). But we need to use a mechanism called “port-forwarding” on the service called service/argocd-server (which is listening on port 80 and 443). By-pass the certificate check, if necessary.
    ```
    kubectl get services -n argocd
    kubectl port-forward service/argocd-server --namespace argocd 8080:443
    ```
    <img src="images/d4-argocd-detail/d4-argocd-detail-07-port-forwarding-443-to-8080.png" width="600" />

7. Run the following command to get the initial password of ArgoCD. You will need it to login
    to the ArgoCD GUI.
    ```
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
    ```
    ```
    kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
    Ti1pLUhJaGM3NkU4cUpOUw==
    
    echo Ti1pLUhJaGM3NkU4cUpOUw== | openssl base64 -d
    N-i-HIhc76E8qJNS <<<<<< This is the ArgoCD initial secret in base64.
    ```
    <img src="images/d4-argocd-detail/d4-argocd-detail-08-decode-initial-password.png" width="600" />

8.  Go to the browser and enter the following address as the URL to access the ArgoCD GUI.
    ```
    http://localhost:8080
    ```
    If prompted that the connection is not private, click the __Advanced__ button and then click the link __Proceed to localhost (unsafe)__.

    <img src="images/d4-argocd-detail/d4-argocd-detail-09-connection-not-private.png" width="600" />

9.  When the ArgoCD GUI is up, enter __admin__ as the __Username__. For the __Password__, enter __N-i-HIhc76E8qJNS__ (Password you obtained in step 7). And then click the __SIGN IN__ button.

    <img src="images/d4-argocd-detail/d4-argocd-detail-10-argocd-login.png" width="600" />

10. This is the ArgoCD landing page.

    <img src="images/d4-argocd-detail/d4-argocd-detail-11-argocd-landing-page.png" width="600" />

18. Within the ArgoCD GUI, click <img src="images/d4-argocd-detail/d4-argocd-detail-12-argocd-new-app.png" width="60" /> and enter the following details:
    -   GENERAL:
        -   Application Name: pred-main-dev
        -   Project Name: default
        -   SYNC POLICY: Automatic
    -   SYNC OPTIONS
        -   __AUTO-CREATE NAMESPACE__: Tick the checkbox
    -   SOURCE
        -   Repository URL: https://github.com/sunnymoon1314/ce5-group5-capstone
        -   Path: helm-app/helm
    -   DESTINATION
        -   Cluster URL: https://kubernetes.default.svc
        -   Namespace: dev
    -   Helm
        -   appName: helm-app
        -   configmap.data.CUSTOM_HEADER: This app was deployed with helm.
        -   configmap.name: helm-app-configmap-v1.0.0
        -   image.name: moonysun1314/ml-model
        -   image.tag: v1.0.0
        -   port: 5000
    -   Helm
        -   VALUES FILES: values.yml

    <img src="images/d4-argocd-detail/d4-argocd-detail-19-create-application-details-1.png" width="600" />

    <img src="images/d4-argocd-detail/d4-argocd-detail-20-create-application-details-2.png" width="600" />

    <img src="images/d4-argocd-detail/d4-argocd-detail-21-create-application-details-3.png" width="600" />

![alt text](image.png)
19. Then click the <img src="images/d4-argocd-detail/d4-argocd-detail-21-create-application.png" width="60" /> button at the top-left corner of the screen.

19. Please wait for the application to show healthy status (i.e. Synchronised/Healthy).

    <img src="images/d4-argocd-detail/d4-argocd-detail-10-show-application.png" width="600" />

22. Use this command to access the application.
    ```
    kubectl port-foward service/helm-app 5000:5000 --namespace dev
    ```
    <img src="images/d4-argocd-detail/d4-argocd-detail-23-port-forwarding-5000-to-5000.png" width="600" />

20. Repeat step 18 and 19 to create a second application, if required.

21. Use this command to check whether our application(s) are running. The number of pods should tally with the number of replicas in the deployment.yml manifest file.
    ```
    kubectl get all --namespace dev
    ```
    <img src="images/d4-argocd-detail/d4-argocd-detail-22-check-application-running.png" width="600" />

26. Release a new version of the ML model by creating a new tag (say v1.0.1) in GitHub and then approve and deploy the new version to the prod environment. You should be able to see ArgoCD synchronise the version from v1.0.0 to v1.0.1.

    <img src="images/d4-argocd-detail/d4-argocd-detail-27-auto-sync-upon-version-update.png" width="600" />















8. Login to ArgoCD via the CLI tool.
    ```
    argocd login 127.0.0.1:8080
    ```
    <img src="images/d4-argocd-detail/d4-argocd-detail-05-helm-repo-addXXX.png" width="600" />

![alt text](image-2.png)

11. Username is admin and the Password is __Zl8khgRMNnsfeh8-__ (Password you obtained in step 8).

12. Type `argocd` and press `Enter` to list all the commands available using argocd.

13. ```
    argocd app list
    ```
    ```
    argocd app create ml-model-prod \
    --repo https://github.com/sunnymoon1314/capstone.git \
    --path predict-maintenance/overlays/prod \
    --dest-server https://kubernetes.default.svc \
    --dest-namespace prod
    --namespace prod

    argocd app sync argocd/ml-model-prod
    ```

    -   GENERAL:
        -   Application Name: helm-app-dev
        -   Project Name: default
        -   SYNC POLICY: Automatic
    -   SYNC OPTIONS
        -   __AUTO-CREATE NAMESPACE__: Tick the checkbox
    -   SOURCE
        -   Repository URL: https://github.com/sunnymoon1314/ce5-group5-capstone
        -   Path: helm-app/helm
    -   DESTINATION
        -   Cluster URL: https://kubernetes.default.svc
        -   Namespace: dev

14. Use the `argocd app list` command to check whether ArgoCD is synchronising the application status. Please allow for sometime for ArgoCD to detect the changes made.

15. Use the `argocd app diff` command to see what changes have been made.
    ```
    argocd app diff ml-model-prod
    ```
    This can also be checked in the GUI.
![alt text](image-3.png)

14. Use the `argocd app history` command to check the previous versions of the selected application.
    ```
    argocd app history ml-model-prod
    ```

14. Use the `argocd app rollback` command to revert the selected application to the previous version, for example, if the current version is found to be unstable.
    ```
    argocd app rollback ml-model-prod 0 <<<<<< 0 is the ID of the desired version to rollback to.
    ```

    ```
    argocd get pods --namespace prod
    ```

14. Use the `argocd app get` command to get more information about the selected application.
    ```
    argocd app get ml-model-prod
    ```

14. Use the `argocd app logs` command to get more information about the previous version(s) of the application.
    ```
    argocd app get ml-model-prod
    ```

14. Use the `argocd app set` command to change any parameter(s), such as path, self-heal, sync-policy, etc.
    ```
    argocd app get ml-model-prod
    ```







14. Use the `argocd app delete` command to delete the application that you no longer need.
    ```
    argocd app delete ml-model-prod
    ```

Reference(s):
-   [Deploy using ArgoCD and Github Actions](https://medium.com/@mssantossousa/deploy-using-argocd-and-github-actions-888f7370e480)
</details>

## <img src="images/3d-ball-icon/green-3d-ball.png" width="35" /> D. Project Summary

Lessons learnt and challenges faced.

## <img src="images/3d-ball-icon/blue-3d-ball.png" width="35" /> E. Suggestions For Future Work

## <img src="images/3d-ball-icon/indigo-3d-ball.png" width="35" /> F. References

### _ArgoCD Image Updater_
Image Source: [Unlocking Advanced Image Management with ArgoCD and ArgoCD Image Updater](https://medium.com/@kittipat_1413/unlocking-advanced-image-management-with-argocd-and-argocd-image-updater-b3c99ab9723a)

<img src="images/d4-argocd-detail-XX-argocd-image-updater.png" width="600" />

kustomize edit set image quay.io/redhatworkshops/welcome-php:ffcd15
https://redhat-scholars.github.io/argocd-tutorial/argocd-tutorial/03-kustomize.html
<img src="images/d4-argocd-detail-XX-kustomize-edit-set-image.png" width="600" />



![alt text](image-5.png)


![alt text](image-10.png)





![alt text](image-11.png)

![alt text](image-12.png)

![alt text](image-13.png)

![alt text](image-14.png)

![alt text](image-15.png)

![alt text](image-16.png)

Outputs:

aks_cluster_location = "westus2"
aks_cluster_name = "aks-cluster-prod"
aks_cluster_resource_group_name = "aks-resource-group-rg"
aks_cluster_version = "1.29"
kubeconfig_command = "az aks get-credentials --resource-group aks-resource-group-rg --name aks-cluster-prod"

![alt text](image-17.png)

![alt text](image-18.png)



