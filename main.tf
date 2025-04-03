module "db_instance" {
  source                              = "./modules/db_instance"
  id                                  = var.id
  kms_policy                          = var.kms_policy
  kms_alias_name                      = var.kms_alias_name
  application_name                    = var.application_name
  app_alias                           = var.app_alias
  identifier                          = var.identifier
  environment                         = var.environment
  engine                              = var.engine
  engine_version                      = var.engine_version
  engine_lifecycle_support            = var.engine_lifecycle_support
  instance_class                      = var.instance_class
  allocated_storage                   = var.allocated_storage
  storage_type                        = var.storage_type
  storage_encrypted                   = var.storage_encrypted
  kms_key_id                          = var.kms_key_id
  license_model                       = var.license_model
  db_name                             = var.db_name
  username                            = var.username
  password                            = var.manage_master_user_password ? null : var.password
  port                                = var.port
  domain                              = var.domain
  domain_auth_secret_arn              = var.domain_auth_secret_arn
  domain_dns_ips                      = var.domain_dns_ips
  domain_fqdn                         = var.domain_fqdn
  domain_iam_role_name                = var.domain_iam_role_name
  domain_ou                           = var.domain_ou
  iam_database_authentication_enabled = var.iam_database_authentication_enabled
  custom_iam_instance_profile         = var.custom_iam_instance_profile
  manage_master_user_password         = var.manage_master_user_password
  manage_master_user_password_rotation = var.manage_master_user_password_rotation
  master_user_password_rotation_schedule_expression = var.master_user_password_rotation_schedule_expression
  master_user_password_rotation_duration = var.master_user_password_rotation_duration
  master_user_secret_kms_key_id = aws_kms_key.cmk-rds-secret.arn

  # master_user_password_rotate_immediately                = var.master_user_password_rotate_immediately
  # master_user_password_rotation_automatically_after_days = var.master_user_password_rotation_automatically_after_days

  vpc_security_group_ids = var.vpc_security_group_ids
  #db_subnet_group_name   = var.db_subnet_group_name
  db_subnet_group_name  = aws_db_subnet_group.rds_db_subnet_group.name
  parameter_group_name   = var.parameter_group_name
  option_group_name      = var.option_group_name
  network_type           = var.network_type

  availability_zone      = var.availability_zone
  multi_az               = var.multi_az
  iops                   = var.iops
  storage_throughput     = var.storage_throughput
  publicly_accessible    = var.publicly_accessible
  ca_cert_identifier     = var.ca_cert_identifier
  dedicated_log_volume   = var.dedicated_log_volume
  upgrade_storage_config = var.upgrade_storage_config

  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  maintenance_window          = var.maintenance_window
  blue_green_update           = var.blue_green_update

  snapshot_identifier              = var.snapshot_identifier
  copy_tags_to_snapshot            = var.copy_tags_to_snapshot
  skip_final_snapshot              = var.skip_final_snapshot
  final_snapshot_identifier_prefix = var.final_snapshot_identifier_prefix

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null

  replicate_source_db                  = var.replicate_source_db
  replica_mode                         = var.replica_mode
  backup_retention_period              = var.backup_retention_period
  backup_window                        = var.backup_window
  max_allocated_storage                = var.max_allocated_storage
  monitoring_interval                  = var.monitoring_interval
  monitoring_role_arn                  = var.monitoring_role_arn
  monitoring_role_name                 = var.monitoring_role_name
  monitoring_role_use_name_prefix      = var.monitoring_role_use_name_prefix
  monitoring_role_description          = var.monitoring_role_description
  create_monitoring_role               = var.create_monitoring_role
  monitoring_role_permissions_boundary = var.monitoring_role_permissions_boundary

  character_set_name       = var.character_set_name
  nchar_character_set_name = var.nchar_character_set_name
  timezone                 = var.timezone

  enabled_cloudwatch_logs_exports        = var.enabled_cloudwatch_logs_exports
  create_cloudwatch_log_group            = var.create_cloudwatch_log_group
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  cloudwatch_log_group_kms_key_id        = var.cloudwatch_log_group_kms_key_id
  cloudwatch_log_group_skip_destroy      = var.cloudwatch_log_group_skip_destroy
  cloudwatch_log_group_class             = var.cloudwatch_log_group_class
  cloudwatch_log_group_tags              = var.cloudwatch_log_group_tags

  timeouts = var.timeouts

  deletion_protection      = var.deletion_protection
  delete_automated_backups = var.delete_automated_backups

  restore_to_point_in_time = var.restore_to_point_in_time
  s3_import                = var.s3_import

  db_instance_tags = var.db_instance_tags
  tags             = var.tags
}