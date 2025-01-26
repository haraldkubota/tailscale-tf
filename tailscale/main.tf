resource "aws_key_pair" "admin" {
  key_name   = "aws-ed25519"
  public_key = "YOUR SSH PUBLIC KEY"
}

resource "cloudflare_dns_record" "ec2_dns_record" {
  zone_id = var.cloudflare_dns_id
  comment = "My Tailscale Gateway"
  content = aws_instance.tailscale.public_ip
  name    = "tsgw-${terraform.workspace}"
  proxied = false
  ttl     = 300
  type    = "A"
}

data "cloudflare_zone" "my_domain" {
  zone_id = var.cloudflare_dns_id
}

output "instance_ips" {
  value = aws_instance.tailscale.public_dns
}

output "cloudflare_dns" {
  value = "${cloudflare_dns_record.ec2_dns_record.name}.${data.cloudflare_zone.my_domain.name}"
}
