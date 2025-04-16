variable "s3_name" {
  description = "Name of S3 bucket"
  type        = string
  default     = null
}
variable "s3_tags" {
  description = "A mapping of tags to assign to S3 bucket"
  type        = map(string)
  default     = {}
}
variable "object_lock_enabled" {
  description = "Indicates whether this bucket has an Object Lock configuration enabled"
  type        = bool
  default     = null
}
variable "s3_bucket_policy" {
  description = "S3 Bucket policy"
  type = string
  default = ""  
}