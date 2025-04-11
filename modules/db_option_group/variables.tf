variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the option group"
  type        = string
  default     = null
}

variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique name beginning with `name` as the specified prefix"
  type        = bool
  default     = false
}
variable "name_prefix" {
  description = "The name prefix of the option group"
  type        = string
  default     = null
}

variable "option_group_description" {
  description = "The description of the option group"
  type        = string
  default     = null
}

variable "engine_name" {
  description = "Specifies the name of the engine that this option group should be associated with"
  type        = string
  default     = null
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = null
}

variable "options" {
  description = "A list of Options to apply"
  type        = any
  default     = []
}

variable "skip_destroy" {
  description = "Set to true if you do not wish the option group to be deleted at destroy time, and instead just remove the option group from the Terraform state"
  type        = bool
  default     = null
}

variable "timeouts" {
  description = "Define maximum timeout for deletion of `aws_db_option_group` resource"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
}
variable "engine" {
  type        = string
  description = "The database engine to use"
}
variable "engine_version" {
  description = "The engine version to use"
  type        = string
}
variable "backup_restore_role_arn" {
  type        = string
  description = "ARN of existing IAM role used for option SQLSERVER_BACKUP_RESTORE"
  default     = null
}
variable "extra_options" {
  description = "Custom options to be appended to default ones in Option Group"
  type        = list(any)
  default     = []
}
variable "sg_ids" {
  description = "List of Security Group IDs"
  type        = list(string)
  default     = []
}