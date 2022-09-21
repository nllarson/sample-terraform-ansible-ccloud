# sample-terraform-ansible-ccloud demo project

Create a self managed Kafka Connect cluster and attach it to a Confluent Cloud cluster for the purpose of starting a replicator connector to move data to the cloud cluster.  

To help in automation, the ansible inventory file is being created through the Terraform tempaltefile function. So as the infrastructure for the connect cluster grows / shrinks, the inventory file can be kept up-to-date.  

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

From there an inventory file will be created in the `ansible` directory named similar to `{ENV}-inventory.yml`.  This file will keep up to date as you add / remove nodes from the connect cluster.  If you are wanting to keep any changes that you make to the inventory file, the changes should be made in `ansible/templates/hosts.tmpl`