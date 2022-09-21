# replicator-automation demo project


### Requirements
* Terraform
* Ansible
* Ansible Galaxy


#### Terraform Notes
* Create Confluent Cloud Account
* Create Environment
* Create Service Account and API Key
* Configure `.tfvars` file with Environment Id and API Key data. (One per environment for this example)

Then:
* `terraform init`
* `terraform plan --var-file ${environment}.tfvars`
* Verify plan looks right
* `terraform apply --var-file ${enviornment}.tfvars`
* `terraform output -json`