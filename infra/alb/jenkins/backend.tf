terraform {
  backend "s3" {
    bucket = "my-terraform-practice"
    key    = "alb/jenkins/terraform.state"
    region = var.region
  }
}
