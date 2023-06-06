terraform {
  backend "s3" {
    bucket = "my-terraform-practice"
    key    = "ec2/jenkins/terraform.state"
    region = var.region
  }
}
