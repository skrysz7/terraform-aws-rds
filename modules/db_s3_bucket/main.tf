resource "aws_s3_bucket" "this" {
  bucket              = var.s3_bucket_name
  tags                = var.s3_bucket_tags
  object_lock_enabled = var.object_lock_enabled
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket
  policy = var.s3_bucket_policy != "" ? var.s3_bucket_policy : local.default_s3_bucket_policy
}