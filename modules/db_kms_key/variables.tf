variable "description" {
  description = "The description of the key as viewed in AWS console"
  type        = string
  default     = null
}
variable "enable_key_rotation" {
  description = "Specifies whether key rotation is enabled"
  type        = bool
  default     = true
}
variable "rotation_period_in_days" {
  description = "Custom period of time between each rotation date. Must be a number between 90 and 2560 (inclusive)"
  type        = number
  default     = 365
}
variable "deletion_window_in_days" {
  description = "The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. If you specify a value, it must be between 7 and 30, inclusive"
  type        = number
  default     = 7
}
variable "kms_policy" {
  description = "A valid policy JSON document for KMS"
  type        = string
  default     = null
}
variable "is_enabled" {
  description = "Specifies whether the key is enabled"
  type        = bool
  default     = true
}
variable "name" {
  description = "The display name of the alias. The name must start with the word 'alias' followed by a forward slash (alias/)"
  type        = string
  default     = null
}
variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
}