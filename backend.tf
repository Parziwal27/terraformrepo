terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket = "my-terraform-state-bucket-pz-20231005"
    key    = "terraform.tfstate"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}
