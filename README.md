## NTU-SCTP Cloud Infrastructure Engineering
## Cohort 5 Group 5 Capstone Project

(1) Git push to dev branch:
- Will trigger the prepare-train-build.yml workflow.
- Upon completion of the workflow, approval is required to push to DockerHub.

(2) Git push to main branch:
- Will trigger the build-push.yml workflow.
- Upon completion of the workflow, approval is required to deploy to ECR.
