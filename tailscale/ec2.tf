data "aws_ami" "amazon_linux_x86_64" {
  most_recent = true

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-kernel-6.1-x86_64"]
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
  ami = data.aws_ami.amazon_linux_x86_64.id
  # ami           = "ami-0a6fd4c92fc6ed7d5"
  instance_type = var.nat_ec2_type
  key_name      = aws_key_pair.admin.key_name
  subnet_id     = aws_subnet.public_subnets[0].id
  vpc_security_group_ids = [
    aws_security_group.ssh_and_https.id
  ]
  associate_public_ip_address = true
  source_dest_check           = false
  root_block_device {
    volume_size = "8"
    volume_type = "gp3"
    encrypted   = "true"
  }
  user_data = <<EOF
#!/bin/bash
echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
curl -fsSL https://tailscale.com/install.sh | sh
echo > /tmp/tailscale.txt 'Run these once:

$ sudo tailscale up --advertise-routes=${var.vpc_cidr_block} --accept-routes

# Now follow the displayed URI, authenticate it,
# disable the key expiry and approve the route setting
# in the Tailscale UI
# And when done:

$ sudo systemctl enable --now tailscaled
'
EOF

  tags = {
    Env  = "${var.environment}"
    Name = "tailscale"
  }
}

# A small EC2 in the private network

resource "aws_instance" "private_ec2" {
  ami = data.aws_ami.amazon_linux_x86_64.id
  # ami = "ami-0a6fd4c92fc6ed7d5"

  instance_type = var.ec2_type
  key_name      = aws_key_pair.admin.key_name
  subnet_id     = aws_subnet.private_subnets[0].id
  vpc_security_group_ids = [
    aws_security_group.ssh_and_https.id
  ]
  associate_public_ip_address = false
  root_block_device {
    volume_size = "8"
    volume_type = "gp3"
    encrypted   = "true"
  }
  tags = {
    Env  = "${var.environment}"
    Name = "Private EC2"
  }
}

