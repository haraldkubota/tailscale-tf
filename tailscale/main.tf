output "instance_ips" {
  value = aws_instance.tailscale.public_ip
}

output "cloudflare_dns" {
  value = "${cloudflare_dns_record.ec2_dns_record.name}.${data.cloudflare_zone.my_domain.name}"
}
