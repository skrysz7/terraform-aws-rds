output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = try(aws_db_instance.this.address, null)
}

output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = try(aws_db_instance.this.arn, null)
}

output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = try(aws_db_instance.this.availability_zone, null)
}

output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = try(aws_db_instance.this.endpoint, null)
}

output "db_listener_endpoint" {
  description = "Specifies the listener connection endpoint for SQL Server Always On"
  value       = try(aws_db_instance.this.listener_endpoint, null)
}

output "db_instance_engine" {
  description = "The database engine"
  value       = try(aws_db_instance.this.engine, null)
}

output "db_instance_engine_version_actual" {
  description = "The running version of the database"
  value       = try(aws_db_instance.this.engine_version_actual, null)
}

output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = try(aws_db_instance.this.hosted_zone_id, null)
}

output "db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = try(aws_db_instance.this.identifier, null)
}

output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = try(aws_db_instance.this.resource_id, null)
}

output "db_instance_status" {
  description = "The RDS instance status"
  value       = try(aws_db_instance.this.status, null)
}

output "db_instance_name" {
  description = "The database name"
  value       = try(aws_db_instance.this.db_name, null)
}

output "db_instance_username" {
  description = "The master username for the database"
  value       = try(aws_db_instance.this.username, null)
  sensitive   = true
}

output "db_instance_port" {
  description = "The database port"
  value       = try(aws_db_instance.this.port, null)
}

output "db_instance_ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  value       = try(aws_db_instance.this.ca_cert_identifier, null)
}

output "db_instance_domain" {
  description = "The ID of the Directory Service Active Directory domain the instance is joined to"
  value       = try(aws_db_instance.this.domain, null)
}

output "db_instance_domain_auth_secret_arn" {
  description = "The ARN for the Secrets Manager secret with the self managed Active Directory credentials for the user joining the domain"
  value       = try(aws_db_instance.this.domain_auth_secret_arn, null)
}

output "db_instance_domain_dns_ips" {
  description = "The IPv4 DNS IP addresses of your primary and secondary self managed Active Directory domain controllers"
  value       = try(aws_db_instance.this.domain_dns_ips, null)
}

output "db_instance_domain_fqdn" {
  description = "The fully qualified domain name (FQDN) of an self managed Active Directory domain"
  value       = try(aws_db_instance.this.domain_fqdn, null)
}

output "db_instance_domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service"
  value       = try(aws_db_instance.this.domain_iam_role_name, null)
}

output "db_instance_domain_ou" {
  description = "The self managed Active Directory organizational unit for your DB instance to join"
  value       = try(aws_db_instance.this.domain_ou, null)
}

output "db_instance_master_user_secret_arn" {
  description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
  value       = aws_db_instance.this.master_user_secret[0].secret_arn
}
output "enabled_cloudwatch_logs_exports" {
  value = var.enabled_cloudwatch_logs_exports
}
output "cloudwatch_log_group_keys" {
  value = [for log in var.enabled_cloudwatch_logs_exports : log if var.create_cloudwatch_log_group]
}
output "db_instance_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = aws_cloudwatch_log_group.this
}
output "db_instance_secretsmanager_secret_rotation_enabled" {
  description = "Specifies whether automatic rotation is enabled for the secret"
  value       = try(aws_secretsmanager_secret_rotation.this.rotation_enabled, null)
}
output "kms_key_arn" {
  description = "KMS key arn"
  value       = try(module.db_kms_key[0].kms_key_arn)
}
output "bucket_name" {
  value = try(module.db_s3_bucket[0].this.bucket)
}
output "db_option_group_arn" {
  description = "The ARN of the db option group"
  value       = try(module.db_option_group[0].this.arn)
}
output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = try(module.db_parameter_group[0].this.arn)
}
