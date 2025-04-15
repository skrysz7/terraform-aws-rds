variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = true
}

variable "name" {
  description = "The name of the DB parameter group"
  type        = string
  default     = null
}

variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique name beginning with `name` as the specified prefix"
  type        = bool
  default     = false
}
variable "name_prefix" {
  description = "The name prefix of the parameter group"
  type        = string
  default     = null
}

variable "parameter_group_description" {
  description = "The description of the DB parameter group"
  type        = string
  default     = null
}

variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = null
}

variable "parameters" {
  description = "A list of DB parameter maps to apply"
  type        = list(map(string))
  default     = []
}

variable "skip_destroy" {
  description = "Set to true if you do not wish the parameter group to be deleted at destroy time, and instead just remove the parameter group from the Terraform state"
  type        = bool
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
variable "extra_parameters" {
  description = "Additional or overriding parameters"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string)
  }))
  default = []
}
variable "engine" {
  type        = string
  description = "The database engine to use"
}
variable "engine_version" {
  description = "The engine version to use"
  type        = string
}
variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
}