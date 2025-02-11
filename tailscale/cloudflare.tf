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
