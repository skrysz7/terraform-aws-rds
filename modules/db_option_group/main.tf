resource "aws_db_option_group" "this" {
  # count = contains(local.option_group_engines, var.engine) ? 1 : 0  # Create option group only for supported engines
  
  name                     = local.name
  name_prefix              = var.name_prefix
  option_group_description = local.option_group_description
  engine_name              = var.engine
  major_engine_version     = local.major_engine_version

  dynamic "option" {
    for_each = local.all_options
    content {
      option_name                    = option.value.option_name
      port                           = lookup(option.value, "port", null)
      version                        = lookup(option.value, "version", null)
      db_security_group_memberships  = lookup(option.value, "db_security_group_memberships", null)
      vpc_security_group_memberships = lookup(option.value, "vpc_security_group_memberships", null)

      dynamic "option_settings" {
        for_each = lookup(option.value, "option_settings", [])
        content {
          name  = lookup(option_settings.value, "name", null)
          value = lookup(option_settings.value, "value", null)
        }
      }
    }
  }
  
  skip_destroy = var.skip_destroy

  tags = merge(
    var.tags,
    {
      "Name" = local.name
    },
  )

  timeouts {
    delete = lookup(var.timeouts, "delete", null)
  }

  lifecycle {
    create_before_destroy = true
  }
}