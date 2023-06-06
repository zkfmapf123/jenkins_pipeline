data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
        bucket = "my-terraform-practice"
        key = "env:/${terraform.workspace}/network/private-vpc/terraform.tfstate"
        region = var.region
    }
}

data "terraform_remote_state" "jenkins" {
    backend ="s3"
    config = {
        bucket = "my-terraform-practice"
        key = "env:/${terraform.workspace}/ec2/jenkins/terraform.state"
        region = var.region
    }
}

output value {
    value = data.terraform_remote_state.vpc.outputs
}