# Region to use
region = "ap-northeast-1"

# Instance types to use
nat_ec2_type = "t2.micro"
ec2_type = "t2.micro"

# The newly created subnets in AWS
# [0] is the complete VPC
# [1] is the public subnet
# [2] is the private subnet
cidr_blocks = [
  "172.31.0.0/16",
  "172.31.1.0/24",
  "172.31.2.0/24",
]

# The CIDR for the on-premise network
cidr_on_prem = "192.168.45.0/24"
