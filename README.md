# Native GCP Dashboard
This repository aims to provide a project dashboard and notification channel to alert for baseline alerts. This deployment will fill the monitoring gap for pilots while enterprise logging and monitoring are established. I also provided an example in a qwiklabs environment, which is a blend of commands to see some of the weeds. 

### Requirements

### Terraform plugins
- [Terraform](https://www.terraform.io/downloads.html) 0.12.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v3.51.0
- [terraform-provider-google-beta](https://github.com/terraform-providers/terraform-provider-google-beta) plugin v3.51.0


### APIs
The following APIs must be enabled in the project:
- Logging: `logging.googleapis.com`
- Monitoring: `monitoring.googleapis.com`

### Service account
The **Terraform service account** used to run this module must have the following IAM Roles:
- `Logging Admin` 
- `Monitoring Admin`

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
- /audit.evtns.csv List of log events I'm working on to monitoring (work in progress)

## Qwiklabs deployment example

### Download deployment code in Cloud Shell

#### Terraform Service Account 
```text
git clone https://github.com/jasonbisson/gcp_service_accounts.git
```

#### Terraform Deployment script
```text
git clone https://github.com/jasonbisson/gcp_terraform_deployment.git
```

#### Monitoring Dashboard
```text
git clone https://github.com/jasonbisson/gcp_metrics_dashboard.git
```

### Deployment Environment 

#### Cloud Shell environment variables & state bucket
```text
export environment=metrics
export project_id=$(gcloud config list --format 'value(core.project)')
gsutil mb gs://$project_id-state
export terraform_module=$HOME/gcp_metrics_dashboard
export terraform_module_config=$HOME/gcp_metrics_dashboard/terraform.tfvars
export terraform_deployment_name=$environment
export project_id=$(gcloud config list --format 'value(core.project)')
```

#### Create Service account for Terraform deployment
```text
~/gcp_service_accounts/create_account.sh $environment
```

#### Update IAM Permissions for student account & service account 
```text
export role="iam.serviceAccountTokenCreator"
gcloud projects add-iam-policy-binding $project_id --member user:$(gcloud auth list --format 'value(account)') --role roles/${role}
gcloud projects add-iam-policy-binding $project_id --member 'serviceAccount:'${environment}'@'${project_id}'.iam.gserviceaccount.com' --role 'roles/owner'
Wait couple minutes for IAM policy update
```

#### Deploy Monitoring dashboard
```text
~/gcp_terraform_deployment/terraform_workflow_token.sh --terraform_service_account $environment --terraform_action plan
~/gcp_terraform_deployment/terraform_workflow_token.sh --terraform_service_account $environment --terraform_action apply
```

#### Analysis of Terraform deployment permissions
```text
git clone https://github.com/jasonbisson/gcp_iam_least_privilege.git
~/gcp_iam_least_privilege/find_iam_permissions.sh --email Terraform service account email --days 1
```

### Just give me script
```text
qwiklabs_metrics.sh
``` 
