locals {
  name = (
    var.name != null && var.name != "" ? var.name : "pg-${var.identifier}"
  ) 

  #option_group_engines = ["sqlserver-ee", "sqlserver-ex", "sqlserver-se", "sqlserver-web", "oracle-ee", "oracle-se", "oracle-se1", "oracle-se2", "mysql", "db2-se", "db2-ae"]
  oracle_engines = ["oracle-ee", "oracle-se", "oracle-se1", "oracle-se2"]
  mssql_engines = ["sqlserver-ee", "sqlserver-ex", "sqlserver-se", "sqlserver-web"]
  # engine           = var.engine
  # engine_version   = var.engine_version
  # engine_parts     = split(".", local.engine_version)
  # major_version    = local.engine_parts[0]
  # minor_version    = tostring(tonumber(local.engine_parts[1]))

  # family = contains(local.mssql_engines, local.engine) ?
  #   "${local.engine}-${local.major_version}.${local.minor_version}" :
  #   (
  #     local.engine == "postgres" ?
  #     "${local.engine}${local.major_version}" :
  #     null
  #   )
  # engine_major_version = split(".", var.engine_version)[0]
  # engine_minor_version = tostring(tonumber(split(".", var.engine_version)[1]))

  family = contains(local.mssql_engines, var.engine) ? "${var.engine}-${split(".", var.engine_version)[0]}.${tostring(tonumber(split(".", var.engine_version)[1]))}" : contains(["postgres"], var.engine) ? "postgres${split(".", var.engine_version)[0]}" : null

  parameter_group_description = (
    var.parameter_group_description != null && var.parameter_group_description != "" ? var.parameter_group_description : ("Parameter group for ${var.identifier}")
  )
  
  
  # default_parameters = contains(local.mssql_engines, var.engine) ? [
  #   {
  #     name  = "cost threshold for parallelism"
  #     value = "50"
  #   },
  #   {
  #     name  = "optimize for ad hoc workloads"
  #     value = "1"
  #   },
  #   {
  #     name  = "max degree of parallelism"
  #     value = "2"
  #   },
  #   {
  #     name         = "rds.force_ssl"
  #     value        = "1"
  #     apply_method = "pending-reboot"
  #   }
  # ] : contains(["postgres"], var.engine) ? [
  #   {
  #     name         = "log_filename"
  #     value        = "postgresql.log.%Y-%m-%d-%H"
  #     apply_method = "pending-reboot"
  #   },
  #   {
  #     name  = "log_min_duration_statement"
  #     value = "60000"
  #   },
  #   {
  #     name  = "log_statement"
  #     value = "all"
  #   },
  #   {
  #     name         = "rds.force_ssl"
  #     value        = "1"
  #     apply_method = "pending-reboot"
  #   },
  #   {
  #     name  = "pgaudit.log"
  #     value = "role,ddl"
  #   }
  # ] : []

  # all_parameters = concat(local.default_parameters, var.extra_parameters)
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