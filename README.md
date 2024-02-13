# TerraformCheatsheet

# To start New Terraform project
1. Create a file with a .tf extension
2. For once, to set your providers we need to do **terraform init**
3. To dry run your code and see your changes do **terraform plan**
4. To run the terraform file write **terraform apply**
5. To delete the resources created by Terraform write **terraform destroy --auto-approve**
6. To delete a particular resource write **terraform destroy -target <resource_type.resource_name>**
7. To apply a particular resource write **terraform apply -target <resource_type.resource_name>**

# Terraform State Commands
6. To see the list of all the state resources we have created: terraform state list
7. To see details about any particular state resource that we have created: terraform state show <resource_name>



