output "ssh_key_pair" {
  value = {
    name        = aws_key_pair.cdp_keypair.key_name
    public_key = trimspace(data.tls_public_key.selected.public_key_openssh)
    type        = aws_key_pair.cdp_keypair.key_type
    fingerprint = aws_key_pair.cdp_keypair.fingerprint
  }
  description = "SSH public key"
}

output "cdp_environment_name" {
  value = module.cdp_deploy.cdp_environment_name
  description = "CDP Environment Name"

}

output "cdp_environment_crn" {
  value = module.cdp_deploy.cdp_environment_crn
  description = "CDP Environment CRN"

}

output "aws_vpc_id" {
  value = module.cdp_deploy.aws_vpc_id
  description = "AWS VPC ID"
}