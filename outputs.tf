output "db_instance_address" {
  description = "The address of the RDS instance"
  value       = module.db_instance.db_instance_address
}
output "db_instance_arn" {
  description = "The ARN of the RDS instance"
  value       = module.db_instance.db_instance_arn
}
output "db_instance_availability_zone" {
  description = "The availability zone of the RDS instance"
  value       = module.db_instance.db_instance_availability_zone
}
output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db_instance.db_instance_endpoint
}
output "db_listener_endpoint" {
  description = "Specifies the listener connection endpoint for SQL Server Always On"
  value       = module.db_instance.db_listener_endpoint
}
output "db_instance_engine" {
  description = "The database engine"
  value       = module.db_instance.db_instance_engine
}
output "db_instance_engine_version_actual" {
  description = "The running version of the database"
  value       = module.db_instance.db_instance_engine_version_actual
}
output "db_instance_hosted_zone_id" {
  description = "The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record)"
  value       = module.db_instance.db_instance_hosted_zone_id
}
output "db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = module.db_instance.db_instance_identifier
}
output "db_instance_resource_id" {
  description = "The RDS Resource ID of this instance"
  value       = module.db_instance.db_instance_resource_id
}
output "db_instance_status" {
  description = "The RDS instance status"
  value       = module.db_instance.db_instance_status
}
output "db_instance_name" {
  description = "The database name"
  value       = module.db_instance.db_instance_name
}
output "db_instance_username" {
  description = "The master username for the database"
  value       = module.db_instance.db_instance_username
  sensitive   = true
}
output "db_instance_domain" {
  description = "The ID of the Directory Service Active Directory domain the instance is joined to"
  value       = module.db_instance.db_instance_domain
}
output "db_instance_domain_auth_secret_arn" {
  description = "The ARN for the Secrets Manager secret with the self managed Active Directory credentials for the user joining the domain"
  value       = module.db_instance.db_instance_domain_auth_secret_arn
}
output "db_instance_domain_dns_ips" {
  description = "The IPv4 DNS IP addresses of your primary and secondary self managed Active Directory domain controllers"
  value       = module.db_instance.db_instance_domain_dns_ips
}
output "db_instance_domain_fqdn" {
  description = "The fully qualified domain name (FQDN) of an self managed Active Directory domain"
  value       = module.db_instance.db_instance_domain_fqdn
}
output "db_instance_domain_iam_role_name" {
  description = "The name of the IAM role to be used when making API calls to the Directory Service"
  value       = module.db_instance.db_instance_domain_iam_role_name
}
output "db_instance_domain_ou" {
  description = "The self managed Active Directory organizational unit for your DB instance to join"
  value       = module.db_instance.db_instance_domain_ou
}
output "db_instance_port" {
  description = "The database port"
  value       = module.db_instance.db_instance_port
}
output "db_instance_ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  value       = module.db_instance.db_instance_ca_cert_identifier
}
output "db_instance_master_user_secret_arn" {
  description = "The ARN of the master user secret (Only available when manage_master_user_password is set to true)"
  value       = module.db_instance.db_instance_master_user_secret_arn
}
output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = module.db_instance.db_parameter_group_arn
}
output "db_option_group_arn" {
  description = "The ARN of the db option group"
  value       = module.db_instance.db_option_group_arn
}
output "db_instance_cloudwatch_log_groups" {
  description = "Map of CloudWatch log groups created and their attributes"
  value       = module.db_instance.db_instance_cloudwatch_log_groups
}
output "db_instance_secretsmanager_secret_rotation_enabled" {
  description = "Specifies whether automatic rotation is enabled for the secret"
  value       = module.db_instance.db_instance_secretsmanager_secret_rotation_enabled
}
output "kms_key_arn" {
  description = "KMS key arn"
  value       = module.db_instance.kms_key_arn
}
output "bucket_name" {
  description = "S3 Bucket name"
  value       = module.db_instance.bucket_name
}