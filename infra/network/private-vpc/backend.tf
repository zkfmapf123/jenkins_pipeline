terraform {
  backend "s3" {
    bucket = "my-terraform-practice"
    key    = "network/private-vpc/terraform.tfstate"
    region = var.region
  }
}
