variable "id" {
  type        = string
  default     = ""
  description = "Instance ID for consolidated instances (e.g., 01, 02, 03, ...)"
}

variable "app_alias" {
  type        = string
  default     = ""
  description = "Application alias (max 8 chars) for individual app instances"
}

variable "environment" {
  type    = string
  validation {
    condition     = contains(["devl", "intg", "nprd", "prod"], lower(var.environment))
    error_message = "Invalid environment. Must be one of: devl, intg, nprd, prod."
  }
}

variable "engine" {
  type        = string
  description = "The database engine to use"
  # validation {
  #   condition     = contains(["ibmdb2", "mssql", "mysql", "oracle", "postgres"], lower(var.engine))
  #   error_message = "Invalid database engine. Must be one of: ibmdb2, mssql, mysql, oracle, postgres."
  # }
}

variable "identifier" {
  description = "The name of the RDS instance"
  type        = string
  default     = null
}
variable "custom_iam_instance_profile" {
  description = "RDS custom iam instance profile"
  type        = string
  default     = null
}
variable "application_name" {
  description = "Application name used in various resource descriptions"
  type        = string
}
variable "kms_alias_name" {
  description = "Custom KMS alias name"
  type        = string
  default     = null
}
variable "kms_policy" {
  description = "Custom KMS policy JSON document"
  type        = string
  default     = null
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = number
  default     = null
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), 'gp3' (new generation of general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. If you specify 'io1' or 'gp3' , you must also include a value for the 'iops' parameter"
  type        = string
  default     = null
}

variable "storage_throughput" {
  description = "Storage throughput value for the DB instance. This setting applies only to the `gp3` storage type. See `notes` for limitations regarding this variable for `gp3`"
  type        = number
  default     = null
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used"
  type        = string
  default     = null
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate."
  type        = string
  default     = null
}

variable "license_model" {
  description = "License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1"
  type        = string
  default     = null
}

variable "replica_mode" {
  description = "Specifies whether the replica is in either mounted or open-read-only mode. This attribute is only supported by Oracle instances. Oracle replicas operate in open-read-only mode unless otherwise specified"
  type        = string
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or mappings of AWS Identity and Access Management (IAM) accounts to database accounts is enabled"
  type        = bool
  default     = false
}

variable "domain" {
  description = "The ID of the Directory Service Active Directory domain to create the instance in"
  type        = string
  default     = null
}

variable "domain_auth_secret_arn" {
  description = "(Optional, but required if domain_fqdn is provided) The ARN for the Secrets Manager secret with the self managed Active Directory credentials for the user joining the domain. Conflicts with domain and domain_iam_role_name."
  type        = string
  default     = null
}

variable "domain_dns_ips" {
  description = "(Optional, but required if domain_fqdn is provided) The IPv4 DNS IP addresses of your primary and secondary self managed Active Directory domain controllers. Two IP addresses must be provided. If there isn't a secondary domain controller, use the IP address of the primary domain controller for both entries in the list. Conflicts with domain and domain_iam_role_name."
  type        = list(string)
  default     = null
}

variable "domain_fqdn" {
  description = "The fully qualified domain name (FQDN) of the self managed Active Directory domain. Conflicts with domain and domain_iam_role_name."
  type        = string
  default     = null
}

variable "domain_iam_role_name" {
  description = "(Required if domain is provided) The name of the IAM role to be used when making API calls to the Directory Service"
  type        = string
  default     = null
}

variable "domain_ou" {
  description = "(Optional, but required if domain_fqdn is provided) The self managed Active Directory organizational unit for your DB instance to join. Conflicts with domain and domain_iam_role_name."
  type        = string
  default     = null
}

# variable "db_engine" {
#   type        = string
#   description = "The database engine to use in identifier"
#   # validation {
#   #   condition     = contains(["ibmdb2", "mssql", "mysql", "oracle", "postgres"], lower(var.engine))
#   #   error_message = "Invalid database engine. Must be one of: ibmdb2, mssql, mysql, oracle, postgres."
#   # }
# }

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = null
}

variable "engine_lifecycle_support" {
  description = "The life cycle type for this DB instance. This setting applies only to RDS for MySQL and RDS for PostgreSQL. Valid values are `open-source-rds-extended-support`, `open-source-rds-extended-support-disabled`. Default value is `open-source-rds-extended-support`."
  type        = string
  default     = null
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default     = null
}

variable "db_name" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = null
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default     = "dbadmin"
}

variable "password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  default     = null
}

variable "manage_master_user_password" {
  description = "Set to true to allow RDS to manage the master user password in Secrets Manager. Cannot be set if password is provided"
  type        = bool
  default     = true
}

variable "master_user_secret_kms_key_id" {
  description = <<EOF
  The key ARN, key ID, alias ARN or alias name for the KMS key to encrypt the master user password secret in Secrets Manager.
  If not specified, the default KMS key for your Amazon Web Services account is used.
  EOF
  type        = string
  # default     = null
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default     = null
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted"
  type        = bool
  default     = false
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05."
  type        = string
  default     = null
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot"
  type        = bool
  default     = true
}

variable "final_snapshot_identifier_prefix" {
  description = "The name which is prefixed to the final snapshot on cluster destroy"
  type        = string
  default     = "final"
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC"
  type        = string
}

variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate"
  type        = string
  default     = null
}

variable "availability_zone" {
  description = "The Availability Zone of the RDS instance"
  type        = string
  default     = null
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1' or `gp3`. See `notes` for limitations regarding this variable for `gp3`"
  type        = number
  default     = null
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  type        = number
  default     = 60
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. Must be specified if monitoring_interval is non-zero."
  type        = string
  default     = null
}

variable "monitoring_role_name" {
  description = "Name of the IAM role which will be created when create_monitoring_role is enabled."
  type        = string
  default     = "rds-monitoring-role"
}

variable "monitoring_role_use_name_prefix" {
  description = "Determines whether to use `monitoring_role_name` as is or create a unique identifier beginning with `monitoring_role_name` as the specified prefix"
  type        = bool
  default     = false
}

variable "monitoring_role_description" {
  description = "Description of the monitoring IAM role"
  type        = string
  default     = null
}

variable "monitoring_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the monitoring IAM role"
  type        = string
  default     = null
}

variable "create_monitoring_role" {
  description = "Create IAM role with a defined name that permits RDS to send enhanced monitoring metrics to CloudWatch Logs."
  type        = bool
  default     = false
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default     = null
}

variable "blue_green_update" {
  description = "Enables low-downtime updates using RDS Blue/Green deployments."
  type        = map(string)
  default     = {}
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = null
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "db_instance_tags" {
  description = "A map of additional tags for the DB instance"
  type        = map(string)
  default     = {}
}

variable "option_group_name" {
  description = "Name of the DB option group to associate."
  type        = string
  default     = null
}

variable "timezone" {
  description = "Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See MSSQL User Guide for more information."
  type        = string
  default     = null
}

variable "character_set_name" {
  description = "The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS and Collations and Character Sets for Microsoft SQL Server for more information. This can only be set on creation."
  type        = string
  default     = null
}

variable "nchar_character_set_name" {
  description = "The national character set is used in the NCHAR, NVARCHAR2, and NCLOB data types for Oracle instances. This can't be changed."
  type        = string
  default     = null
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
  type        = list(string)
  default     = []
}

variable "timeouts" {
  description = "Updated Terraform resource management timeouts. Applies to `aws_db_instance` in particular to permit resource management times"
  type        = map(string)
  default     = {}
}

variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  type        = bool
  default     = true
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)."
  type        = number
  default     = 7
}

variable "performance_insights_kms_key_id" {
  description = "The ARN for the KMS key to encrypt Performance Insights data."
  type        = string
  default     = null
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 0
}

variable "ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  type        = string
  default     = null
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
  type        = bool
  default     = true
}

variable "s3_import" {
  description = "Restore from a Percona Xtrabackup in S3 (only MySQL is supported)"
  type        = map(string)
  default     = null
}


variable "restore_to_point_in_time" {
  description = "Restore to a point in time (MySQL is NOT supported)"
  type        = map(string)
  default     = null
}

variable "network_type" {
  description = "The type of network stack"
  type        = string
  default     = null
}

variable "dedicated_log_volume" {
  description = "Use a dedicated log volume (DLV) for the DB instance. Requires Provisioned IOPS."
  type        = bool
  default     = false
}

variable "upgrade_storage_config" {
  description = "Whether to upgrade the storage file system configuration on the read replica. Can only be set with replicate_source_db."
  type        = bool
  default     = null
}

################################################################################
# CloudWatch Log Group
################################################################################

variable "create_cloudwatch_log_group" {
  description = "Determines whether a CloudWatch log group is created for each `enabled_cloudwatch_logs_exports`"
  type        = bool
  default     = false
}

variable "cloudwatch_log_group_retention_in_days" {
  description = "The number of days to retain CloudWatch logs for the DB instance"
  type        = number
  default     = 7
}

variable "cloudwatch_log_group_kms_key_id" {
  description = "The ARN of the KMS Key to use when encrypting log data"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_skip_destroy" {
  description = "Set to true if you do not wish the log group (and any logs it may contain) to be deleted at destroy time, and instead just remove the log group from the Terraform state"
  type        = bool
  default     = null
}

variable "cloudwatch_log_group_class" {
  description = "Specified the log class of the log group. Possible values are: STANDARD or INFREQUENT_ACCESS"
  type        = string
  default     = null
}

variable "cloudwatch_log_group_tags" {
  description = "Additional tags for the CloudWatch log group(s)"
  type        = map(string)
  default     = {}
}

################################################################################
# Managed Secret Rotation
################################################################################

variable "manage_master_user_password_rotation" {
  description = "Whether to manage the master user password rotation. By default, false on creation, rotation is managed by RDS. Setting this value to false after previously having been set to true will disable automatic rotation."
  type        = bool
  default     = true
}

variable "master_user_password_rotate_immediately" {
  description = "Specifies whether to rotate the secret immediately or wait until the next scheduled rotation window."
  type        = bool
  default     = null
}

variable "master_user_password_rotation_automatically_after_days" {
  description = "Specifies the number of days between automatic scheduled rotations of the secret. Either automatically_after_days or schedule_expression must be specified."
  type        = number
  default     = null
}

variable "master_user_password_rotation_duration" {
  description = "The length of the rotation window in hours. For example, 3h for a three hour window."
  type        = string
  default     = "3h"
}

variable "master_user_password_rotation_schedule_expression" {
  description = "A cron() or rate() expression that defines the schedule for rotating your secret. Either automatically_after_days or schedule_expression must be specified."
  type        = string
  default     = "cron(0 20 ? * SUN#1 *)" # Runs at 20:00 UTC (8 PM) on the first Sunday of every month
}
variable "backup_restore_role_arn" {
  type        = string
  description = "ARN of existing IAM role used for option SQLSERVER_BACKUP_RESTORE"
  default     = null
}
variable "extra_options" {
  description = "Custom options to be appended to default ones"
  type        = list(any)
  default     = []
}