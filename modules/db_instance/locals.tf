locals {
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
  }
  
  db_engine = lookup(local.engine_mapping, var.engine, var.engine)  # Default to original engine if not found

  identifier = (
    var.app_alias != "" ? 
    "db-${lower(var.db_engine)}-${lower(var.app_alias)}-${lower(var.environment)}" : 
    "db-${lower(var.db_engine)}-${var.id}-${lower(var.environment)}"
  )
  

  ########################
  monitoring_role_arn = var.create_monitoring_role ? aws_iam_role.enhanced_monitoring[0].arn : var.monitoring_role_arn

  monitoring_role_name        = var.monitoring_role_use_name_prefix ? null : var.monitoring_role_name
  monitoring_role_name_prefix = var.monitoring_role_use_name_prefix ? "${var.monitoring_role_name}-" : null

  # Replicas will use source metadata
  is_replica = var.replicate_source_db != null
}
