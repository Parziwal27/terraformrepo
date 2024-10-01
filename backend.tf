terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket = "my-terraform-state-bucket-pz-202310056"
    key    = "terraform.tfstate"
    region = "ap-south-1"
  }

}
