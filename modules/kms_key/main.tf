resource "aws_kms_key" "this" {
  description             = var.description != "" ? var.description : "Symmetric AWS CMK for RDS Storage for ${var.application_name}"
  enable_key_rotation = var.enable_key_rotation
  rotation_period_in_days = var.rotation_period_in_days
  deletion_window_in_days = var.deletion_window_in_days
  is_enabled = var.is_enabled
  policy = var.policy
}

resource "aws_kms_alias" "this" {
  name          = var.name != "" ? var.name : "alias/cmk-${var.identifier}"
  target_key_id = aws_kms_key.this.key_id
}