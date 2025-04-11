resource "aws_s3_bucket" "this" {
  bucket = var.s3_name
  tags = var.s3_tags
  object_lock_enabled = var.object_lock_enabled
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.bucket
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Id": "shared-tools-bucket-policy",
    "Statement": [
      {
        "Sid": "ShareBucketXMSWide",
        "Effect": "Allow",
        "Principal": {
            "AWS": "*"
        },
        "Action": [
            "s3:GetObject",
            "s3:List*"
        ],
        "Resource": [
            "arn:aws:s3:::${aws_s3_bucket.this.id}/*",
            "arn:aws:s3:::${aws_s3_bucket.this.id}"
        ],
        "Condition": {
            "ForAnyValue:StringLike" : {
                "aws:PrincipalOrgPaths" : [
                  "o-xxx/*/ou-xxx-xxx/*"
                ]
            }
          }
      },
      {
        "Sid": "ShareBucketWithAccount",
        "Effect": "Allow",
        "Principal": {
            "AWS": "arn:aws:iam::342023131128:root"
        },
        "Action": [
            "s3:List*",
            "s3:PutObject",
            "s3:GetObject",
            "s3:DeleteObject"
        ],
        "Resource": [
            "arn:aws:s3:::${aws_s3_bucket.this.id}/*",
            "arn:aws:s3:::${aws_s3_bucket.this.id}"
        ]
      }
    ]
  }
  POLICY
}