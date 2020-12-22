# Native GCP Dashboard
This repository aims to provide a project dashboard and notification channel to alert for baseline alerts. This deployment will fill the monitoring gap for pilots while enterprise logging and monitoring are established. I also provided an example in a qwiklabs environment, which is a blend of commands to see some of the weeds. 

### Requirements

### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.12.x
- [terraform-provider-google](https://github.com/terraform-providers terraform-provider-google) plugin v3.51.0
- [terraform-provider-google-beta](https://github.com/terraform-providers/terraform-provider-google-beta) plugin v3.51.0


### APIs
The following APIs must be enabled in the project:
- Logging: `logging.googleapis.com`
- Monitoring: `monitoring.googleapis.com`

### Service account
***Terraform service account** (that will create the Monitoring infrastructure)

The **Terraform service account** used to run this module must have the following IAM Roles:
- `Logging Admin` 

## Install

### Terraform
-  Create a Google Storage bucket to store Terraform state 
-  `gsutil mb gs://<your state bucket>`
-  Copy terraform.tfvars.template to terraform.tfvars 
-  `cp terraform.tfvars.template  terraform.tfvars`
-  Update required variables in terraform.tfvars for Splunk Software, GCS Bucket, and DNS configuration 
- `terraform init` to get the plugins
-  Enter Google Storage bucket that will store the Terraform state
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure

#### Variables
Please refer the `variables.tf` file for the required and optional variables.

## File structure
The project has the following folders and files:

- /main.tf: main file for this module, contains all the resources to create
- /variables.tf: all the variables for the module
- /terraform.tfvars.template template of required variables
- /readme.MD: this file

## Qwiklabs deployment example

### Download deployment code in Cloud Shell

#### Terraform Service Account 
- git clone https://github.com/jasonbisson/gcp_service_accounts.git

#### Terraform Deployment script
- git clone https://github.com/jasonbisson/gcp_terraform_deployment.git

#### Monitoring Dashboard
- export environment=<your environment name>
- mkdir $environment
- cd $environment
- git clone https://github.com/jasonbisson/gcp_metrics_dashboard.git

### Deployment Environment 

#### Cloud Shell environment variables & state bucket
- export project_id=$(gcloud config list --format 'value(core.project)')
- gsutil mb gs://$project_id-state
- export terraform_module=$HOME/$environment
- export terraform_module_config=$HOME/$environment/terraform.tfvars
- export terraform_deployment_name=$environment
- export project_id=$(gcloud config list --format 'value(core.project)')

#### Create Service account for Terraform deployment


#### Update IAM Permissions for student account & service account 
- export role="iam.serviceAccountTokenCreator"
- gcloud projects add-iam-policy-binding $project_id --member user:$(gcloud auth list --format 'value(account)') --role roles/${role}
- gcloud projects add-iam-policy-binding $project_id --member 'serviceAccount:'${environment}'@'${project_id}'.iam.gserviceaccount.com' --role 'roles/owner'

#### Deploy Monitoring dashboard


#### Analysis of Terraform deployment permissions
- git clone https://github.com/jasonbisson/gcp_iam_least_privilege.git
- find_iam_permissions.sh --email <Terraform service account email> --days 1


