data "terraform_remote_state" "vpc" {
    backend = "s3"
    config = {
        bucket = "my-terraform-practice"
        key = "env:/${terraform.workspace}/network/private-vpc/terraform.tfstate"
        region = var.region
    }
}

output "vpc" {
    value = data.terraform_remote_state.vpc.outputs
}