# Ref. https://docs.aws.amazon.com/general/latest/gr/aws-arns-and-namespaces.html#genref-aws-service-namespaces
data "aws_partition" "current" {}

module "kms_key" {
  source            = "../kms_key"
  application_name  = var.application_name
  identifier   = local.identifier
  policy = var.kms_policy
  name       = var.kms_alias_name
}

resource "aws_db_instance" "this" {
  identifier               = local.identifier
  # application_name         = var.application_name
  engine                   = var.engine
  engine_version           = var.engine_version
  engine_lifecycle_support = var.engine_lifecycle_support
  instance_class           = var.instance_class
  allocated_storage        = var.allocated_storage
  storage_type             = var.storage_type
  storage_encrypted        = var.storage_encrypted
  kms_key_id               = var.kms_key_id != null ? var.kms_key_id : module.kms_key.kms_key_arn
  license_model            = local.license_model

  db_name                             = var.db_name
  # username                            = !local.is_replica ? var.username : null
  # password                            = !local.is_replica && var.manage_master_user_password ? null : var.password
  username = var.username
  password = var.password
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

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
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
  maintenance_window          = local.maintenance_window

  # https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/blue-green-deployments.html
  dynamic "blue_green_update" {
    for_each = length(var.blue_green_update) > 0 ? [var.blue_green_update] : []

    content {
      enabled = try(blue_green_update.value.enabled, null)
    }
  }

  snapshot_identifier       = var.snapshot_identifier
  copy_tags_to_snapshot     = var.copy_tags_to_snapshot
  skip_final_snapshot       = var.skip_final_snapshot
  #final_snapshot_identifier = local.final_snapshot_identifier

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  performance_insights_kms_key_id       = var.performance_insights_enabled ? var.performance_insights_kms_key_id : null

  replicate_source_db     = var.replicate_source_db
  replica_mode            = var.replica_mode
  backup_retention_period = local.backup_retention_period
  backup_window           = local.backup_window
  max_allocated_storage   = var.max_allocated_storage
  monitoring_interval     = var.monitoring_interval
  monitoring_role_arn     = var.monitoring_interval > 0 ? local.monitoring_role_arn : null

  character_set_name              = local.character_set_name
  nchar_character_set_name        = var.nchar_character_set_name
  timezone                        = var.timezone
  enabled_cloudwatch_logs_exports = local.enabled_cloudwatch_logs_exports

  deletion_protection      = var.deletion_protection
  delete_automated_backups = var.delete_automated_backups

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

  tags = merge(var.tags, var.db_instance_tags, 
          {
           "xxx:service:name" = var.application_name 
          })

  depends_on = [aws_cloudwatch_log_group.this]

  timeouts {
    create = lookup(var.timeouts, "create", null)
    delete = lookup(var.timeouts, "delete", null)
    update = lookup(var.timeouts, "update", null)
  }

  # Note: do not add `latest_restorable_time` to `ignore_changes`
  # https://github.com/terraform-aws-modules/terraform-aws-rds/issues/478
}

################################################################################
# CloudWatch Log Group
################################################################################

# Log groups will not be created if using an identifier prefix
resource "aws_cloudwatch_log_group" "this" {
  #for_each = toset([for log in var.enabled_cloudwatch_logs_exports : log if var.create && var.create_cloudwatch_log_group && !var.use_identifier_prefix])

  name              = "/aws/rds/instance/${local.identifier}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id
  skip_destroy      = var.cloudwatch_log_group_skip_destroy
  log_group_class   = var.cloudwatch_log_group_class

  tags = merge(var.tags, var.cloudwatch_log_group_tags)
}

################################################################################
# Enhanced monitoring
################################################################################

data "aws_iam_policy_document" "enhanced_monitoring" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "enhanced_monitoring" {
  count = var.create_monitoring_role ? 1 : 0

  name                 = local.monitoring_role_name
  name_prefix          = local.monitoring_role_name_prefix
  assume_role_policy   = data.aws_iam_policy_document.enhanced_monitoring.json
  description          = var.monitoring_role_description
  permissions_boundary = var.monitoring_role_permissions_boundary

  tags = merge(
    {
      "Name" = format("%s", var.monitoring_role_name)
    },
    var.tags,
  )
}

resource "aws_iam_role_policy_attachment" "enhanced_monitoring" {
  count = var.create_monitoring_role ? 1 : 0

  role       = aws_iam_role.enhanced_monitoring[0].name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

################################################################################
# Managed Secret Rotation
################################################################################

resource "aws_secretsmanager_secret_rotation" "this" {
  secret_id = aws_db_instance.this.master_user_secret[0].secret_arn
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

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowuseoftheSecretforaccount",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action    = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource  = data.aws_secretsmanager_secret.this.arn
      },
      {
        Sid       = "AllowAccessForExternalAccount",
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::1234567890:root" # set it to ms-sql account
        },
        Action    = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource  = data.aws_secretsmanager_secret.this.arn
      }
    ]
  })
}