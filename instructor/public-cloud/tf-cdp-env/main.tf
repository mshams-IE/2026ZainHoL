terraform {
  required_version = ">= 1.5.7"
  required_providers {
    cdp = {
      source  = "cloudera/cdp"
      version = ">= 0.6.1"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # ignore tags created by data services
  ignore_tags {
    key_prefixes = ["kubernetes.io/cluster"]
  }
}

# ------- SSH Keypair -------
locals {
  # Determine if we need to generate a keypair
  create_keypair = var.ssh_private_key_file == null ? true : false

  # Path to the private key file to use
  private_key_file = local.create_keypair ? abspath(local_sensitive_file.pem_file[0].filename) : abspath(pathexpand(var.ssh_private_key_file))
}

# Generate a new private key if needed
resource "tls_private_key" "generated_private_key" {
  count     = local.create_keypair ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the generated private key to a file if needed
resource "local_sensitive_file" "pem_file" {
  count                = local.create_keypair ? 1 : 0
  filename             = "../${var.env_prefix}-ssh-key.pem"
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.generated_private_key[0].private_key_pem
}

# Load the public key from the correct private key file
data "tls_public_key" "selected" {
  private_key_openssh = local.create_keypair ? tls_private_key.generated_private_key[0].private_key_openssh : file(abspath(pathexpand(var.ssh_private_key_file)))
}

# Create the AWS EC2 keypair from the selected public key
resource "aws_key_pair" "cdp_keypair" {
  key_name   = "${var.env_prefix}-keypair"
  public_key = trimspace(data.tls_public_key.selected.public_key_openssh)
}

# ------- CDP Environment Deployment -------
module "cdp_deploy" {
    source = "git::https://github.com/cloudera-labs/cdp-tf-quickstarts.git//aws"
    
    env_prefix = var.env_prefix
    aws_region = var.aws_region
    
    ingress_extra_cidrs_and_ports = var.ingress_extra_cidrs_and_ports

    deployment_template = var.deployment_template
    datalake_scale      = var.datalake_scale   
    cdp_groups          = var.cdp_groups
    
    aws_key_pair        = aws_key_pair.cdp_keypair.key_name

    env_tags = var.env_tags
}

##### Support 'attaching' an extra buckets to the environment #####
  # Use the CDP Terraform Provider to find the xaccount account, external ids and policy contents
  data "cdp_environments_aws_credential_prerequisites" "cdp_prereqs" {}

  # ...process placeholders in the policy doc
  locals {
    data_bucket_access_policy_doc   = base64decode(data.cdp_environments_aws_credential_prerequisites.cdp_prereqs.policies["Bucket_Access"])

    extra_bucket_access_policies = [
      for bucket in var.extra_s3_buckets :
        replace(
    replace(
    local.data_bucket_access_policy_doc, "$${ARN_PARTITION}", "aws"),
  "$${DATALAKE_BUCKET}", bucket)
    ]  
  }

  # ...create the extra policies
resource "aws_iam_policy" "cdp_extra_bucket_data_access_policy" {

  count = length(var.extra_s3_buckets)

  name        = "${var.env_prefix}-extra-data-policy-${var.extra_s3_buckets[count.index]}"
  description = "CDP Data Access for additional bucket ${var.extra_s3_buckets[count.index]}"

  tags = merge(var.env_tags, { Name = "${var.env_prefix}-extra-data-policy-${var.extra_s3_buckets[count.index]}" })

  policy = local.extra_bucket_access_policies[count.index]

}

# Attach policy to DL admin role
resource "aws_iam_role_policy_attachment" "cdp_datalake_admin_role_extra_bucket" {

  for_each = { for k , v in aws_iam_policy.cdp_extra_bucket_data_access_policy: k => v}

  # role       = module.cdp_deploy.aws_datalake_admin_role_name # TODO: Need to expose this as a variable
  role       = "${var.env_prefix}-dladmin-role"
  policy_arn = each.value.arn

  depends_on = [ module.cdp_deploy ]
}
