terraform {
  backend "s3" {
    bucket = "my-terraform-practice"
    key    = "ec2/bastion/terraform.state"
    region = var.region
  }
}
