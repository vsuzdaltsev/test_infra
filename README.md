# test_infra
 1. set proper tags within variable "default_tags"   
 2. replace PROJECT string with project name:
   sed -i 's/PROJECT/<project_name>/g' *.tf   
 
 3. terraform init   
 4. terraform plan   
 5. terraform apply   
