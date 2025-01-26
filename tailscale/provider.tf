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
    dev  = "arn:aws:iam::YOUR_AWS_DEV_ACCOUNT_ID:user/admin"
    prod = "arn:aws:iam::YOUR_AWS_PROD_ACCOUNT_ID:user/admin"
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
