# Region to use
region = "ap-northeast-1"
azs    = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]

# Instance types to use
nat_ec2_type = "t2.micro"
ec2_type     = "t2.micro"

# The newly created VPC and subnets in AWS

vpc_cidr_block = "10.8.0.0/16"

public_subnet_cidrs = [
  "10.8.1.0/24", "10.8.3.0/24", "10.8.5.0/24"
]

private_subnet_cidrs = [
  "10.8.2.0/24", "10.8.4.0/24", "10.8.6.0/24"
]

# The CIDR for the on-premise network
cidr_on_prem = "192.168.4.0/24"
