data "aws_vpc" "default" {
  default    = true
  cidr_block = var.cidr_blocks[0]
}

# Get availability zones (no local zones)
data "aws_availability_zones" "nolocal" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

resource "aws_security_group" "ssh_and_https" {
  name        = "ssh-and-https"
  description = "Allow incoming and outgoing traffic on port 22 and 443"
  vpc_id      = data.aws_vpc.default.id
  ingress {
    description = "SSH ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create 2 subnets in one AZ
# Optionally create 2 more in another AZ

resource "aws_subnet" "public" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = var.cidr_blocks[1]
  availability_zone = data.aws_availability_zones.nolocal.names[0]
  tags = {
    Env = "prod"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = data.aws_vpc.default.id
  cidr_block        = var.cidr_blocks[2]
  availability_zone = data.aws_availability_zones.nolocal.names[0]
  tags = {
    Env = "prod"
  }
}

# Get the default Internet GW
data "aws_internet_gateway" "default" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Route Table for Public Subnet
# Does Internet (by default) and Tailscale network and on-prem
resource "aws_route_table" "public" {
  vpc_id = data.aws_vpc.default.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.default.id
  }
  # route {
  #   cidr_block = "100.64.0.0/10"
  #   network_interface_id = aws_instance.tailscale.primary_network_interface_id
  # }
  # route {
  #   cidr_block           = var.cidr_on_prem
  #   network_interface_id = aws_instance.tailscale.primary_network_interface_id
  # }
  tags = {
    Name = "Public Subnet Route Table"
  }
}

# Private subnet does not need to know anything about Tailscale
# Only needs to know how to reach the on-prem network
resource "aws_route_table" "private" {
  vpc_id = data.aws_vpc.default.id
  route {
    cidr_block           = var.cidr_on_prem
    network_interface_id = aws_instance.tailscale.primary_network_interface_id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

