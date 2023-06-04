# Jenkins Pipeline

> Terraform Backend

- gloabl.tfvars로 region을 구별합니다.

```
terraform init -backend-config="../../gb.tfvars"
terraform workspace new [version]

terraform plan -var-file="path to gb.tfvars"
terraform apply -var=file="path to gb.tfvars"

```
