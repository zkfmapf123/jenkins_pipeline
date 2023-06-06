# Jenkins Pipeline

![jenkins](./public/jenkins.png)

> Terraform Backend

- gloabl.tfvars로 region을 구별합니다.

```
terraform init -backend-config="../../gb.tfvars"
terraform workspace new [version]

terraform plan -var-file="path to gb.tfvars"
terraform apply -var=file="path to gb.tfvars"

```

> Bastion Host -> Private Subnet 접속

```
    1. ssh를 복사한 후 Bastion host ~/.ssh/id_rsa로 복사
    2. ssh로 접속
```

> Init Step

```
    > network/private-vpc
    > ec2/bastion
    > alb/jenkins-alb
    ...

    추후 golang으로 자동화 pipeline 구성해야 함
```

> Todo (Infra)

- [x] Init VPC Setting
- [x] Basiton host (Public)
- [x] ALB use Jenkins
- [x] Jenkins (Private)
