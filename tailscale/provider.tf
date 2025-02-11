terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.0.0-rc1"
    }
  }
}


variable "workspace_iam_roles" {
  default = {
    dev  = "arn:aws:iam::DEV-AWS-ID:role/Terraform"
    prod = "arn:aws:iam::PROD-AWS-ID:user/admin"
  }
}

variable "aws_cli_profile" {
  default = {
    dev  = "default"
    prod = "admin_prod"
  }
}

provider "aws" {
  region  = "${var.region}"
  profile = var.aws_cli_profile[terraform.workspace]
}


provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
