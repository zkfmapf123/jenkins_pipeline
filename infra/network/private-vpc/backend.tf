terraform {
  backend "s3" {
    bucket = "my-terraform-practice"
    key    = "network/private-vpc/terraform.state"
    region = var.region
  }
}
