resource "aws_key_pair" "key_pair" {
  key_name = "bastion_key_pair"
  public_key = file(local.ssh_config.pulbic_ssh_path)
}

module "ssh" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = local.ssh_config.name
  description = local.ssh_config.description
  vpc_id      = local.vpc_config.vpc_id

  ingress_cidr_blocks = local.ssh_config.ingress_cidr_blocks
  ingress_rules       = local.ssh_config.ingress_rules
  egress_rules        = local.ssh_config.egress_rules

  tags = {
    Name = "${terraform.workspace}_bastion_ssh"
  }
}

module "ec2" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = local.ec2_config.name

  ami                         = local.ec2_config.ami
  key_name                    = aws_key_pair.key_pair.key_name
  instance_type               = local.ec2_config.instance_type
  availability_zone           = element(keys(local.vpc_config.public_subnets),0)
  subnet_id                   = element(values(local.vpc_config.public_subnets),0)
  vpc_security_group_ids      = [module.ssh.security_group_id, local.vpc_config.default_security_group_id]
  associate_public_ip_address = true

  tags = {
      Name = "${terraform.workspace}_ec2_bastion_host"
  }
}
