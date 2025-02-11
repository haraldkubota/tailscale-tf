variable "region" {
  type    = string
  default = "ap-northeast-1"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = []
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = []
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = []
}

variable ec2_type {
  type    = string
  default = "t2.micro"
}

variable nat_ec2_type {
  type    = string
  default = "t2.micro"
}

variable "ssh_key_name" {
  type    = string
  default = "aws-ed25519"
}

variable "price_limit" {
  type    = number
  default = 0.1
}

variable "name_prefix" {
  type    = string
  default = "ts-"
}

# List of cidr blocks
variable "vpc_cidr_block" {
  type        = string
  description = "VPC CIDR"
}

variable "cidr_on_prem" {
  type        = string
  description = "The on-prem network"
}

variable "environment" {
  type    = string
  default = "Dev"
}

variable "cloudflare_api_token" {
  type = string
}

variable "cloudflare_dns_id" {
  type = string
}

