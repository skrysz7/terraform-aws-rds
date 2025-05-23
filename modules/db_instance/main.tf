module "db_kms_key" {
  source     = "../db_kms_key"
  count      = var.create_kms_key ? 1 : 0
  identifier = local.identifier
  kms_policy = var.kms_policy
  name       = var.kms_alias_name
}

module "db_option_group" {
  source                   = "../db_option_group"
  count                    = var.option_group_create && contains(local.option_group_engines, var.engine) ? 1 : 0
  identifier               = local.identifier
  name                     = var.option_group_name
  engine                   = var.engine
  engine_version           = var.engine_version
  backup_restore_role_arn  = var.backup_restore_role_arn
  extra_options            = var.extra_options
  major_engine_version     = var.major_engine_version
  option_group_description = var.option_group_description
  sg_ids                   = [aws_security_group.this[0].id]
}

module "db_parameter_group" {
  source                      = "../db_parameter_group"
  count                       = var.parameter_group_create ? 1 : 0
  identifier                  = local.identifier
  name                        = var.parameter_group_name
  engine                      = var.engine
  engine_version              = var.engine_version
  extra_parameters            = var.extra_parameters
  family                      = var.family
  parameter_group_description = var.parameter_group_description
}

module "db_s3_bucket" {
  count               = var.create_s3_bucket ? 1 : 0
  source              = "../db_s3_bucket"
  s3_bucket_name      = local.s3_bucket_name
  s3_bucket_tags      = var.s3_bucket_tags
  object_lock_enabled = var.object_lock_enabled
  s3_bucket_policy    = var.s3_bucket_policy
}
resource "aws_db_instance" "this" {
  identifier                          = local.identifier
  engine                              = var.engine
  engine_version                      = var.engine_version
  engine_lifecycle_support            = var.engine_lifecycle_support
  instance_class                      = var.instance_class
  allocated_storage                   = var.allocated_storage
  storage_type                        = var.storage_type
  storage_encrypted                   = var.storage_encrypted
  kms_key_id                          = var.kms_key_id != null ? var.kms_key_id : module.db_kms_key[0].kms_key_arn
  license_model                       = local.license_model
  db_name                             = var.db_name
  password                            = var.manage_master_user_password ? null : var.password
  username                            = var.username
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
  master_user_secret_kms_key_id       = var.master_user_secret_kms_key_id
  vpc_security_group_ids              = compact(concat(var.vpc_security_group_ids, var.security_group_create ? [aws_security_group.this[0].id] : []))
  db_subnet_group_name                = var.db_subnet_group_name
  parameter_group_name                = var.parameter_group_name != null && var.parameter_group_name != "" ? var.parameter_group_name : module.db_parameter_group[0].db_parameter_group_name
  option_group_name                   = var.option_group_name != null && var.option_group_name != "" ? var.option_group_name : module.db_option_group[0].db_option_group_name
  network_type                        = var.network_type
  availability_zone                   = var.availability_zone
  multi_az                            = var.multi_az
  iops                                = var.iops
  storage_throughput                  = var.storage_throughput
  publicly_accessible                 = var.publicly_accessible
  ca_cert_identifier                  = var.ca_cert_identifier
  dedicated_log_volume                = var.dedicated_log_volume
  upgrade_storage_config              = var.upgrade_storage_config
  allow_major_version_upgrade         = var.allow_major_version_upgrade
  auto_minor_version_upgrade          = var.auto_minor_version_upgrade
  apply_immediately                   = var.apply_immediately
  maintenance_window                  = local.maintenance_window
  dynamic "blue_green_update" {
    for_each = length(var.blue_green_update) > 0 ? [var.blue_green_update] : []

    content {
      enabled = try(blue_green_update.value.enabled, null)
    }
  }

  snapshot_identifier                   = var.snapshot_identifier
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  skip_final_snapshot                   = var.skip_final_snapshot
  final_snapshot_identifier             = var.final_snapshot_identifier
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null
  replicate_source_db                   = var.replicate_source_db
  replica_mode                          = var.replica_mode
  backup_retention_period               = var.backup_retention_period != null && var.backup_retention_period != "" ? var.backup_retention_period : local.backup_retention_period
  backup_window                         = local.backup_window
  max_allocated_storage                 = var.max_allocated_storage
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = var.monitoring_interval > 0 ? local.monitoring_role_arn : null
  character_set_name                    = local.character_set_name
  nchar_character_set_name              = var.nchar_character_set_name
  timezone                              = var.timezone
  enabled_cloudwatch_logs_exports       = local.enabled_cloudwatch_logs_exports
  deletion_protection                   = var.deletion_protection
  delete_automated_backups              = var.delete_automated_backups

  dynamic "restore_to_point_in_time" {
    for_each = var.restore_to_point_in_time != null ? [var.restore_to_point_in_time] : []

    content {
      restore_time                             = lookup(restore_to_point_in_time.value, "restore_time", null)
      source_db_instance_automated_backups_arn = lookup(restore_to_point_in_time.value, "source_db_instance_automated_backups_arn", null)
      source_db_instance_identifier            = lookup(restore_to_point_in_time.value, "source_db_instance_identifier", null)
      source_dbi_resource_id                   = lookup(restore_to_point_in_time.value, "source_dbi_resource_id", null)
      use_latest_restorable_time               = lookup(restore_to_point_in_time.value, "use_latest_restorable_time", null)
    }
  }

  dynamic "s3_import" {
    for_each = var.s3_import != null ? [var.s3_import] : []

    content {
      source_engine         = "mysql"
      source_engine_version = s3_import.value.source_engine_version
      bucket_name           = s3_import.value.bucket_name
      bucket_prefix         = lookup(s3_import.value, "bucket_prefix", null)
      ingestion_role        = s3_import.value.ingestion_role
    }
  }

  tags = merge(local.tags, var.extra_tags)

  depends_on = [aws_cloudwatch_log_group.this]

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }
}

################################################################################
# CloudWatch Log Group
################################################################################
resource "aws_cloudwatch_log_group" "this" {
  for_each = toset([for log in local.enabled_cloudwatch_logs_exports : log if var.create_cloudwatch_log_group])

  name              = "/aws/rds/instance/${local.identifier}/${each.key}"
  retention_in_days = local.cloud_watch_log_retention
  kms_key_id        = var.cloudwatch_log_group_kms_key_id
  skip_destroy      = var.cloudwatch_log_group_skip_destroy
  log_group_class   = var.cloudwatch_log_group_class

  tags = merge(var.tags, var.cloudwatch_log_group_tags)
}

################################################################################
# Managed Secret Rotation
################################################################################

resource "aws_secretsmanager_secret_rotation" "this" {
  secret_id          = aws_db_instance.this.master_user_secret[0].secret_arn
  rotate_immediately = var.master_user_password_rotate_immediately

  rotation_rules {
    automatically_after_days = var.master_user_password_rotation_automatically_after_days
    duration                 = var.master_user_password_rotation_duration
    schedule_expression      = var.master_user_password_rotation_schedule_expression
  }
}
data "aws_secretsmanager_secret" "this" {
  arn = try(aws_db_instance.this.master_user_secret[0].secret_arn, null)
}

resource "aws_secretsmanager_secret_policy" "this" {
  secret_arn = data.aws_secretsmanager_secret.this.arn
  policy     = var.secret_policy != "" ? var.secret_policy : local.default_secret_policy
}
################################################################################
# Security Group
################################################################################

resource "aws_security_group" "this" {
  count       = var.security_group_create ? 1 : 0
  name        = local.security_group_name
  description = "Security group for RDS ${local.identifier}"
  vpc_id      = data.aws_vpc.this.id

  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = lookup(ingress.value, "description", null)
    }
  }

  dynamic "egress" {
    for_each = local.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
      description = lookup(egress.value, "description", null)
    }
  }

  tags = merge(var.security_group_tags, { "Name" = local.security_group_name })
}
