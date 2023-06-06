locals {
    jenkins_config = jsondecode(file("../../config/jenkins-ec2.json"))

    vpc_config = data.terraform_remote_state.vpc.outputs
    ec2_config = local.jenkins_config.ec2
    http_config = local.jenkins_config.http
}