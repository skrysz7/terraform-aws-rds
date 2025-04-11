locals {
  name = (
    var.name != null && var.name != "" ? var.name : "og-${var.identifier}"
  ) 

  option_group_engines = ["sqlserver-ee", "sqlserver-ex", "sqlserver-se", "sqlserver-web", "oracle-ee", "oracle-se", "oracle-se1", "oracle-se2", "mysql", "db2-se", "db2-ae"]
  oracle_engines = ["oracle-ee", "oracle-se", "oracle-se1", "oracle-se2"]
  mssql_engines = ["sqlserver-ee", "sqlserver-ex", "sqlserver-se", "sqlserver-web"]
  major_engine_version = (
    var.major_engine_version != null && var.major_engine_version != "" ?
    var.major_engine_version : (
      contains(local.oracle_engines, var.engine) ?
      join(".", slice(split(".", var.engine_version), 0, 1)) :
      join(".", slice(split(".", var.engine_version), 0, 2))
    )
  )
  option_group_description = (
    var.option_group_description != null && var.option_group_description != "" ? var.option_group_description : ("Option group for ${var.identifier}")
  )
  
  
  default_options = contains(local.mssql_engines, var.engine) && var.backup_restore_role_arn != null ? [
    {
      option_name                    = "SQLSERVER_BACKUP_RESTORE"
      port                           = null
      version                        = null
      db_security_group_memberships  = null
      vpc_security_group_memberships = null
      option_settings = [
        {
          name  = "IAM_ROLE_ARN"
          value = var.backup_restore_role_arn
        }
      ]
    }
  ] : contains(local.oracle_engines, var.engine) ? [
    {
      option_name                    = "SSL"
      port                           = null
      version                        = null
      db_security_group_memberships  = null
      vpc_security_group_memberships = var.sg_name
      option_settings = [
        {
          name  = "SQLNET.SSL_VERSION"
          value = "1.2"
        },
        {
          name  = "SQLNET.CIPHER_SUITE"
          value = "SSL_RSA_WITH_AES_256_CBC_SHA"
        },
        {
          name  = "FIPS.SSLFIPS_140"
          value = "true"
        }
      ]
    }
  ] : []

  all_options = concat(local.default_options, var.extra_options)

}