resource "aws_key_pair" "key_pair" {
  key_name = "jenkins_key_pair"
  public_key = file(local.http_config.pulbic_ssh_path)
}

# http sg
module "http" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.http_config.name
  description = local.http_config.description
  vpc_id      = local.vpc_config.vpc_id

  ingress_cidr_blocks = local.http_config.http_ingress_cidr_blocks
  ingress_rules       = local.http_config.http_ingress_rules
  egress_rules        = local.http_config.http_egress_rules

  tags = {
    Name = "${terraform.workspace}_jenkins_sg"
  }
}

module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = local.ec2_config.name

  ami                         = local.ec2_config.ami
  key_name                    = aws_key_pair.key_pair.key_name
  instance_type               = local.ec2_config.instance_type

  availability_zone           = element(keys(local.vpc_config.private_subnets),0)
  subnet_id                   = element(values(local.vpc_config.private_subnets),0)
  vpc_security_group_ids      = [module.http.security_group_id]
  associate_public_ip_address = true

  private_ip = local.ec2_config.private_ip

  tags = {
      Name = "${terraform.workspace}_ec2_jenkins"
  }
}
