#!/bin/bash
#set -x
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function download_code () {
    git clone https://github.com/jasonbisson/gcp_terraform_deployment.git
    git clone https://github.com/jasonbisson/gcp_metrics_dashboard.git
    git clone https://github.com/jasonbisson/gcp_service_accounts.git
}

function setup_deployment_environment () {
    export environment=metrics
    ~/gcp_service_accounts/create_service_account.sh --name $environment
    export terraform_module=$HOME/gcp_metrics_dashboard
    export terraform_module_config=$HOME/gcp_metrics_dashboard/terraform.tfvars
    export terraform_deployment_name=$environment
    export project_id=$(gcloud config list --format 'value(core.project)')
    export role="iam.serviceAccountTokenCreator"
    gsutil mb gs://$project_id-state
    gcloud projects add-iam-policy-binding $project_id --member 'serviceAccount:'${environment}'@'${project_id}'.iam.gserviceaccount.com' --role 'roles/owner'
    gcloud projects add-iam-policy-binding $project_id --member user:$(gcloud auth list --format 'value(account)') --role roles/${role}
}

function copy_template () {
    cp terraform.tfvars.template terraform.tfvars
}

function manual_task () {
    printf "Update custom values in $HOME/gcp_metrics_dashboard/terraform.tfvars"
}

function terraform_plan () {
    ~/gcp_terraform_deployment/terraform_workflow_token.sh --terraform_service_account $environment --terraform_action plan
}

function terraform_apply () {
    ~/gcp_terraform_deployment/terraform_workflow_token.sh --terraform_service_account $environment --terraform_action apply
}


download_code
setup_deployment_environment
copy_template
manual_task
terraform_plan
terraform_apply 



