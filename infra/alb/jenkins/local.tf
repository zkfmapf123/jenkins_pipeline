locals {
    jenkins_alb_config = jsondecode(file("../../config/jenkins-alb.json"))

    vpc_config = data.terraform_remote_state.vpc.outputs
    jenkins_ec2_config = data.terraform_remote_state.jenkins.outputs
    http_config = local.jenkins_alb_config.http
}