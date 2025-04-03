resource "aws_kms_key" "this" {
  description             = var.description != null ? var.description : "Symmetric AWS CMK for RDS Storage for ${var.application_name}"
  enable_key_rotation = var.enable_key_rotation
  rotation_period_in_days = var.rotation_period_in_days
  deletion_window_in_days = var.deletion_window_in_days
  is_enabled = var.is_enabled
  policy = var.policy != null ? var.policy : jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "Enable IAM User Permissions for the account"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action = "kms:*"
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_alias" "this" {
  name          = var.name != null ? var.name : "alias/cmk-${var.identifier}"
  target_key_id = aws_kms_key.this.key_id
}