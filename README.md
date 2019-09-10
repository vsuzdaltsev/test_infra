# test_infra
 1. Set proper tags within variable "default_tags"   
 2. replace PROJECT string with project name:   
   ```sed -i 's/PROJECT/<project_name>/g' *.tf```   
 
 3. Get terraform modules   
 ```terraform init```   
 4. Show plan   
 ```terraform plan```   
 5. Apply configuration   
 ```terraform apply```   
