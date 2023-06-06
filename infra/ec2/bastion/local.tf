locals {
    
    bastion_config = jsondecode(file("../../config/bastion-ec2.json"))

    vpc_config = data.terraform_remote_state.vpc.outputs
    ec2_config = local.bastion_config.ec2
    ssh_config = local.bastion_config.ssh
}