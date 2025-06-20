locals {
  engine_mapping = {
    "sqlserver-ee"  = "mssql"
    "sqlserver-ex"  = "mssql"
    "sqlserver-se"  = "mssql"
    "sqlserver-web" = "mssql"
    "postgres"      = "postgres"
    "oracle-ee"     = "oracle"
    "oracle-se"     = "oracle"
    "oracle-se1"    = "oracle"
    "oracle-se2"    = "oracle"
    "mysql"         = "mysql"
    "db2-se"        = "ibmdb2"
    "db2-ae"        = "ibmdb2"
  }

  db_engine = (
    lookup(local.engine_mapping, var.engine, var.engine) # Default to original engine if not found
  )

  normalized_env = lower(var.environment) == "non-prod" ? "nprd" : lower(var.environment)

  # If identifier is not provided then TF creates it dynamically based on provided app_alias or id
  identifier = (
    var.identifier != null && var.identifier != "" ? var.identifier :
    (var.app_alias != "" ?
      "db-${lower(local.db_engine)}-${lower(var.app_alias)}-${local.normalized_env}" :
      (var.id != "" ? "db-${lower(local.db_engine)}-${var.id}-${local.normalized_env}" : "")
    )
  )

  backup_retention_period_mapping = {
    "prod"     = 30
    "non-prod" = 15
    "intg"     = 15
    "devl"     = 15
    "test"     = 15
    "poc"      = 15
  }
  backup_retention_period = lookup(local.backup_retention_period_mapping, lower(var.environment), 15) # By defailt 15, if environment is unknown
  backup_window_mapping = {
    "prod"     = "20:00-01:00"
    "non-prod" = "19:00-00:00"
    "intg"     = "19:00-00:00"
    "devl"     = "19:00-00:00"
    "test"     = "19:00-00:00"
    "poc"      = "19:00-00:00"
  }
  backup_window = (
    var.backup_window != null && var.backup_window != "" ? var.backup_window : lookup(local.backup_window_mapping, lower(var.environment), "19:00-00:00") # By defailt "19:00-00:00", if environment is unknown
  )

  maintenance_window_mapping = {
    "prod"     = "Fri:01:00-Fri:04:00"
    "non-prod" = "Tue:00:00-Tue:03:00"
    "intg"     = "Tue:00:00-Tue:03:00"
    "devl"     = "Tue:00:00-Tue:03:00"
    "test"     = "Tue:00:00-Tue:03:00"
    "poc"      = "Tue:00:00-Tue:03:00"
  }
  maintenance_window = (
    var.maintenance_window != null && var.maintenance_window != "" ? var.maintenance_window : lookup(local.maintenance_window_mapping, lower(var.environment), "Tue:00:00-Tue:03:00")
  )

  sqlserver_engines = ["sqlserver-ee", "sqlserver-ex", "sqlserver-se", "sqlserver-web"]

  character_set_name = (
    var.character_set_name != null && var.character_set_name != "" ? var.character_set_name : (contains(local.sqlserver_engines, var.engine) ? "Latin1_General_CI_AS" : null)
  )
  timezone = (
    var.timezone != null && var.timezone != "" ? var.timezone : (contains(local.sqlserver_engines, var.engine) ? "GMT Standard Time" : null)
  )

  cloud_watch_log_mapping = {
    "sqlserver-ee"  = ["error", "agent"]
    "sqlserver-ex"  = ["error", "agent"]
    "sqlserver-se"  = ["error", "agent"]
    "sqlserver-web" = ["error", "agent"]
    "postgres"      = ["postgresql", "upgrade"]
    "oracle-ee"     = ["alert", "listener", "trace"]
    "oracle-se"     = ["alert", "listener", "trace"]
    "oracle-se1"    = ["alert", "listener", "trace"]
    "oracle-se2"    = ["alert", "listener", "trace"]
    #"mysql" = []
    "db2-se" = ["diag", "notify"]
    "db2-ae" = ["diag", "notify"]
  }
  enabled_cloudwatch_logs_exports = (
    length(var.enabled_cloudwatch_logs_exports) > 0 ? var.enabled_cloudwatch_logs_exports :
    lookup(local.cloud_watch_log_mapping, var.engine, [])
  )
  cloud_watch_log_retention_mapping = {
    "prod"     = 30
    "non-prod" = 14
    "intg"     = 14
    "devl"     = 14
    "test"     = 14
    "poc"      = 14
  }
  cloud_watch_log_retention = coalesce(var.cloudwatch_log_group_retention_in_days, lookup(local.cloud_watch_log_retention_mapping, var.environment, null))

  license_model_mapping = {
    "sqlserver-ee"  = "license-included"
    "sqlserver-ex"  = "license-included"
    "sqlserver-se"  = "license-included"
    "sqlserver-web" = "license-included"
    "postgres"      = "postgresql-license"
    "oracle-ee"     = "bring-your-own-license"
    "oracle-se"     = "license-included"
    "oracle-se1"    = "license-included"
    "oracle-se2"    = "license-included"
  }
  license_model = (
    var.license_model != null && var.license_model != "" ? var.license_model : lookup(local.license_model_mapping, var.engine, "license-included")
  )

  monitoring_role_arn = (
    var.monitoring_role_arn != null && var.monitoring_role_arn != "" ? var.monitoring_role_arn : ("arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/rds-monitoring-role")
  )

  backup_policy_mapping = {
    "prod"     = "rds_prod"
    "non-prod" = "rds_nonprod"
    "intg"     = "rds_nonprod"
    "devl"     = "rds_nonprod"
    "test"     = "rds_nonprod"
    "poc"      = "rds_nonprod"
  }

  tags = {
    "glo:m:any:stage"                 = var.environment
    "glo:m:any:leanix-application-id" = var.leanixid
    "xms:xxx:backup_policy"           = lookup(local.backup_policy_mapping, var.environment, null)
    "xms:xxx:backup_enabled"          = local.backup_retention_period > 0 ? "true" : "false"
    "xms:xxx:finma:backup:enabled"    = var.finma_backup_enabled
  }

  db_port_mapping = {
    "sqlserver-ee"  = 1433
    "sqlserver-ex"  = 1433
    "sqlserver-se"  = 1433
    "sqlserver-web" = 1433
    "postgres"      = 5432
    "oracle-ee"     = 1521
    "oracle-se"     = 1521
    "oracle-se1"    = 1521
    "oracle-se2"    = 1521
  }

  port = (
    var.port != null && var.port != "" ? var.port : lookup(local.db_port_mapping, var.engine)
  )
  # default_ingress = [{
  #   from_port   = local.port
  #   to_port     = local.port
  #   protocol    = "tcp"
  #   cidr_blocks = [data.aws_vpc.this.cidr_block]
  #   description = "Allow RDS traffic from inside VPC"
  # }]
  
  egress_rules  = var.extra_egress

  security_group_name = (var.security_group_name != null && var.security_group_name != "" ? var.security_group_name : "fw-${local.identifier}")
  s3_bucket_name      = (var.s3_bucket_name != null && var.s3_bucket_name != "" ? var.s3_bucket_name : "s3-${local.identifier}")

  option_group_engines = ["sqlserver-ee", "sqlserver-ex", "sqlserver-se", "sqlserver-web", "oracle-ee", "oracle-se", "oracle-se1", "oracle-se2", "mysql", "db2-se", "db2-ae"]

  default_secret_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AllowuseoftheSecretforaccount",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = data.aws_secretsmanager_secret.this.arn
      },
      {
        Sid    = "AllowAccessForExternalAccount",
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::342023131128:root" # set it to ms-sql account
        },
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = data.aws_secretsmanager_secret.this.arn
      }
    ]
  })
# Domyślne reguły MSSQL
  mssql_ingress_rules = [
    {
      from_port   = 1433
      to_port     = 1433
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
      description = "Private network class A to MSSQL access"
    },
    {
      from_port   = 1433
      to_port     = 1433
      protocol    = "tcp"
      cidr_blocks = ["172.16.0.0/12"]
      description = "Private network class B to MSSQL access"
    },
    {
      from_port   = 1433
      to_port     = 1433
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/16"]
      description = "Private network class C to MSSQL access"
    }
  ]

  # Reguły Oracle
  oracle_ingress_rules = [
    {
      from_port   = 1521
      to_port     = 1521
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
      description = "Private network class A to Oracle access"
    },
    {
      from_port   = 1521
      to_port     = 1521
      protocol    = "tcp"
      cidr_blocks = ["172.16.0.0/12"]
      description = "Private network class B to Oracle access"
    },
    {
      from_port   = 1521
      to_port     = 1521
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/16"]
      description = "Private network class C to Oracle access"
    },
    {
      from_port   = 1522
      to_port     = 1522
      protocol    = "tcp"
      cidr_blocks = ["10.0.0.0/8"]
      description = "Private network class A to Oracle TCPS access"
    },
    {
      from_port   = 1522
      to_port     = 1522
      protocol    = "tcp"
      cidr_blocks = ["172.16.0.0/12"]
      description = "Private network class B to Oracle TCPS access"
    },
    {
      from_port   = 1522
      to_port     = 1522
      protocol    = "tcp"
      cidr_blocks = ["192.168.0.0/16"]
      description = "Private network class C to Oracle TCPS access"
    }
  ]
  # Wybór reguł na podstawie engine
  engine_based_ingress = (
    local.db_engine == "oracle" ? local.oracle_ingress_rules :
    local.db_engine == "mssql" ? local.mssql_ingress_rules :
    []
  )
  # Połączone reguły (dodatkowe + zależne od engine)
  ingress_rules = concat(local.engine_based_ingress, var.extra_ingress)
}
