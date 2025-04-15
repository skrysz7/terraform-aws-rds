locals {
  name = (
    var.name != null && var.name != "" ? var.name : "pg-${var.identifier}"
  )
  oracle_engines = ["oracle-ee", "oracle-se", "oracle-se1", "oracle-se2"]
  mssql_engines  = ["sqlserver-ee", "sqlserver-ex", "sqlserver-se", "sqlserver-web"]
  family = contains(local.mssql_engines, var.engine) ? "${var.engine}-${split(".", var.engine_version)[0]}.${tostring(tonumber(split(".", var.engine_version)[1]))}" : contains(["postgres"], var.engine) ? "postgres${split(".", var.engine_version)[0]}" : contains(local.oracle_engines, var.engine) ? "${var.engine}-${split(".", var.engine_version)[0]}" : null

  parameter_group_description = (
    var.parameter_group_description != null && var.parameter_group_description != "" ? var.parameter_group_description : ("Parameter group for ${var.identifier}")
  )

  default_parameters_map = contains(local.mssql_engines, var.engine) ? {
    "cost threshold for parallelism" = {
      value = "50"
    }
    "optimize for ad hoc workloads" = {
      value = "1"
    }
    "max degree of parallelism" = {
      value = "2"
    }
    "rds.force_ssl" = {
      value        = "1"
      apply_method = "pending-reboot"
    }
    } : contains(["postgres"], var.engine) ? {
    "log_filename" = {
      value        = "postgresql.log.%Y-%m-%d-%H"
      apply_method = "pending-reboot"
    }
    "log_min_duration_statement" = {
      value = "60000"
    }
    "log_statement" = {
      value = "all"
    }
    "rds.force_ssl" = {
      value        = "1"
      apply_method = "pending-reboot"
    }
    "pgaudit.log" = {
      value = "role,ddl"
    }
  } : {}

  extra_parameters_map = {
    for p in var.extra_parameters : p.name => {
      value        = p.value
      apply_method = lookup(p, "apply_method", null)
    }
  }

  merged_parameters_map = merge(local.default_parameters_map, local.extra_parameters_map)

  merged_parameters = [
    for name, param in local.merged_parameters_map : {
      name         = name
      value        = param.value
      apply_method = lookup(param, "apply_method", null)
    }
  ]
}