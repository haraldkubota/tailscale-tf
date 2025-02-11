resource "aws_key_pair" "admin" {
  key_name   = "aws-ed25519"
  public_key = "YOUR-PUBLIC-ED25519-SSH-KEY"
}
