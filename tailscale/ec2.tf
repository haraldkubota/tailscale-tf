data "aws_ami" "amazon_linux_x86_64" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["amazon"]
}

# Tailscale EC2 in the public subnet

resource "aws_instance" "tailscale" {
  ami           = data.aws_ami.amazon_linux_x86_64.id
  instance_type = var.nat_ec2_type
  key_name      = aws_key_pair.admin.key_name
  subnet_id     = aws_subnet.public.id
  vpc_security_group_ids = [
    aws_security_group.ssh_and_https.id
  ]
  associate_public_ip_address = true
  source_dest_check           = false
  root_block_device {
    volume_size = "3"
    volume_type = "gp2"
    encrypted   = "true"
  }
  tags = {
    Env  = "${var.environment}"
    Name = "tailscale"
  }
}

# A small EC2 in the private network

resource "aws_instance" "private_ec2" {
  ami           = data.aws_ami.amazon_linux_x86_64.id
  instance_type = var.ec2_type
  key_name      = aws_key_pair.admin.key_name
  subnet_id     = aws_subnet.private.id
  vpc_security_group_ids = [
    aws_security_group.ssh_and_https.id
  ]
  associate_public_ip_address = false
  root_block_device {
    volume_size = "5"
    volume_type = "gp2"
    encrypted   = "true"
  }
  tags = {
    Env  = "${var.environment}"
    Name = "Private EC2"
  }
}

