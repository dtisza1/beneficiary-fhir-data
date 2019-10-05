# Locate the S3 bucket that stores the RIF data to be processed by the BFD Pipeline application.
#
data "aws_s3_bucket" "rif" {
  bucket = "bfd-${var.env_config.env}-etl-${var.launch_config.account_id}"
}

# Locate the customer master key for this environment.
#
data "aws_kms_key" "master_key" {
  key_id = "alias/bfd-${var.env_config.env}-cmk"
}

# Security group for application-specific (i.e. non-management) traffic.
#
resource "aws_security_group" "app" {
  name          = "bfd-${var.env_config.env}-etl-app"
  description   = "Access specific to the BFD Pipeline application."
  vpc_id        = var.env_config.vpc_id
  tags          = merge({Name="bfd-${var.env_config.env}-etl-app"}, var.env_config.tags)

  # Note: The application does not currently listen on any ports, so no ingress rules are needed.

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# App access to the database
#
resource "aws_security_group_rule" "allow_db_primary_access" {
  type                      = "ingress"
  from_port                 = 5432
  to_port                   = 5432
  protocol                  = "tcp"
  description               = "Allows BFD Pipeline access to the primary DB."

  security_group_id         = var.db_config.db_sg         # The SG associated with the primary DB.
  source_security_group_id  = aws_security_group.app.id   # The EC2 instance for the BFD Pipeline app.
}

# IAM policy and role to allow the BFD Pipeline read-write access to ETL bucket.
#
resource "aws_iam_policy" "bfd_pipeline_rif" {
  name        = "bfd-${var.env_config.env}-pipeline-rw-s3-rif"
  description = "Allow the BFD Pipeline application to read-write the S3 bucket with the RIF in it."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "BFD Pipeline RW S3 RIF: KMS",
      "Action": ["kms:Decrypt"],
      "Effect": "Allow",
      "Resource": ["${data.aws_kms_key.master_key.arn}"]
    },
    {
      "Sid": "BFD Pipeline RW S3 RIF: List Bucket",
      "Action": ["s3:ListBucket"],
      "Effect": "Allow",
      "Resource": ["${data.aws_s3_bucket.rif.arn}"]
    },
    {
      "Sid": "BFD Pipeline RW S3 RIF: Read Write Objects",
      "Action": [
        "s3:ListBucket",
        "s3:GetBucketLocation",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": ["${data.aws_s3_bucket.rif.arn}/*"]
    }
  ]
}
EOF
}

module "iam_profile_bfd_pipeline" {
  source = "../iam"

  env_config      = var.env_config
  name            = "bfd_pipeline"
}

resource "aws_iam_role_policy_attachment" "bfd_pipeline_rif" {
  role            = module.iam_profile_bfd_pipeline.role
  policy_arn      = aws_iam_policy.bfd_pipeline_rif.arn
}

# Give the BFD Pipeline app read access to the Ansible Vault PW.
#
data "aws_iam_policy" "ansible_vault_pw_ro_s3" {
  arn           = "arn:aws:iam::${var.launch_config.account_id}:policy/bfd-ansible-vault-pw-ro-s3"
}

resource "aws_iam_role_policy_attachment" "bfd_pipeline_iam_ansible_vault_pw_ro_s3" {
  role            = module.iam_profile_bfd_pipeline.role
  policy_arn      = data.aws_iam_policy.ansible_vault_pw_ro_s3.arn
}

# EC2 Instance to run the BFD Pipeline app.
#
module "ec2_instance" {
  source = "../ec2"

  env_config      = var.env_config
  role            = "etl"
  layer           = "data"
  az              = "us-east-1b" # Same as the master db

  launch_config   = {
    instance_type = "m5.2xlarge"
    volume_size   = 100 # GB
    ami_id        = var.launch_config.ami_id

    key_name      = var.launch_config.ssh_key_name
    profile       = module.iam_profile_bfd_pipeline.profile
    user_data_tpl = "pipeline_server.tpl"
    git_branch    = var.launch_config.git_branch
    git_commit    = var.launch_config.git_commit
  }

  mgmt_config     = {
    vpn_sg        = var.mgmt_config.vpn_sg
    tool_sg       = var.mgmt_config.tool_sg
    remote_sg     = var.mgmt_config.remote_sg
    ci_cidrs      = var.mgmt_config.ci_cidrs
  }

  sg_ids          = [aws_security_group.app.id]

  # Ensure that the DB is accessible before the BFD Pipeline is launched.
  ec2_depends_on_1 = "aws_security_group_rule.allow_db_primary_access"
}
