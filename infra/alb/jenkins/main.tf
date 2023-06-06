# http sg
module "http" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.http_config.name
  description = local.http_config.desc
  vpc_id      = local.vpc_config.vpc_id

  ingress_cidr_blocks = local.http_config.http_ingress_cidr_blocks
  ingress_rules       = local.http_config.http_ingress_rules
  egress_rules        = local.http_config.http_egress_rules

  tags = {
    Name = "${terraform.workspace}_jenkins_alb_sg"
  }
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "jenkins-alb"

  load_balancer_type = "application"

  vpc_id                  = local.vpc_config.vpc_id
  security_groups         = [module.http.security_group_id]
  subnets                 = values(local.vpc_config.public_subnets)

  http_tcp_listeners      = [
  {
    port        = 80
    protocol    = "HTTP"
    action_type = "fixed-response"
    fixed_response = {
      content_type = "text/plain"
      message_body = "Not found"
      status_code  = "403"
    }
  }
]

  http_tcp_listener_rules = [
  {
    http_listener_index = 0
    actions = [{
      type               = "forward"
      target_group_index = 0
    }]
    conditions = [{
      path_patterns = ["/*"]
    }]
  }
]

  target_groups           = [
    {
      name_prefix      = "tg-"
      backend_protocol = "HTTP"
      backend_port     = "8080"
      target_type      = "instance"

      targets = {
        jenkins = {
          target_id = local.jenkins_ec2_config.id
          port      = 8080
        }
      }
    }
  ]

  tags = {
    Name = "${terraform.workspace}_jenkins_alb"
  }
}