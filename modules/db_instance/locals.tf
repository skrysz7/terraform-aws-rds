locals {
  environment       = var.environment
  app_alias         = var.app_alias
  id                = var.id

  engine_mapping = {
    "sqlserver-ee" = "mssql"
    "sqlserver-ex" = "mssql"
    "sqlserver-se" = "mssql"
    "sqlserver-web" = "mssql"
    "postgres" = "postgres"
    "oracle-ee" = "oracle"
    "oracle-se" = "oracle"
    "oracle-se1" = "oracle"
    "oracle-se2" = "oracle"
    "mysql" = "mysql"
    "db2-se" = "ibmdb2"
    "db2-ae" = "ibmdb2"
  }
  
  db_engine = lookup(local.engine_mapping, var.engine, var.engine)  # Default to original engine if not found

  # identifier = (
  #   var.app_alias != "" ? 
  #   "db-${lower(local.db_engine)}-${lower(var.app_alias)}-${lower(var.environment)}" : 
  #   (var.id != "" ? "db-${lower(local.db_engine)}-${var.id}-${lower(var.environment)}" : "")
  # )

  # If identifier is not provided then TF creates it dynamically based on provided app_alias or id
  identifier = (
    var.identifier != null && var.identifier != "" ? var.identifier :
    (var.app_alias != "" ? 
      "db-${lower(local.db_engine)}-${lower(var.app_alias)}-${lower(var.environment)}" : 
      (var.id != "" ? "db-${lower(local.db_engine)}-${var.id}-${lower(var.environment)}" : "")
    )
  )
  backup_retention_period_mapping = {
    "prod"  = 30
    "nprd"  = 15
    "intg"  = 15
    "devl"  = 15
  }
  backup_retention_period = lookup(local.backup_retention_period_mapping, lower(var.environment), 15) # By defailt 15, if environment is unknown
  backup_window_mapping = {
    "prod"  = "20:00-01:00"
    "nprd"  = "19:00-00:00"
    "intg"  = "19:00-00:00"
    "devl"  = "19:00-00:00"
  }
  backup_window = lookup(local.backup_window_mapping, lower(var.environment), "19:00-00:00") # By defailt "19:00-00:00", if environment is unknown
  
  sqlserver_engines = ["sqlserver-ee", "sqlserver-ex", "sqlserver-se", "sqlserver-web"]
  
  character_set_name = contains(local.sqlserver_engines, var.engine) ? "Latin1_General_CI_AS" : null

  cloud_watch_log_mapping = {
    "sqlserver-ee" = ["error", "agent"]
    "sqlserver-ex" = ["error", "agent"]
    "sqlserver-se" = ["error", "agent"]
    "sqlserver-web" = ["error", "agent"]
    "postgres" = ["postgresql", "upgrade"]
    "oracle-ee" = ["alert", "listener", "trace"]
    "oracle-se" = ["alert", "listener", "trace"]
    "oracle-se1" = ["alert", "listener", "trace"]
    "oracle-se2" = ["alert", "listener", "trace"]
    #"mysql" = []
    "db2-se" = ["diag", "notify"]
    "db2-ae" = ["diag", "notify"]
  }
  enabled_cloudwatch_logs_exports = (
    length(var.enabled_cloudwatch_logs_exports) > 0 ? var.enabled_cloudwatch_logs_exports :
    lookup(local.cloud_watch_log_mapping, var.engine, [])
  )


  ########################
  monitoring_role_arn = var.create_monitoring_role ? aws_iam_role.enhanced_monitoring[0].arn : var.monitoring_role_arn

  monitoring_role_name        = var.monitoring_role_use_name_prefix ? null : var.monitoring_role_name
  monitoring_role_name_prefix = var.monitoring_role_use_name_prefix ? "${var.monitoring_role_name}-" : null

  # Replicas will use source metadata
  is_replica = var.replicate_source_db != null
}
