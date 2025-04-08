resource "aws_db_parameter_group" "this" {
  count = var.create ? 1 : 0

  name        = local.name
  name_prefix = var.name_prefix
  description = local.parameter_group_description
  family      = local.family

  dynamic "parameter" {
    for_each = local.all_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = lookup(parameter.value, "apply_method", null)
    }
  }

  skip_destroy = var.skip_destroy

  tags = merge(
    var.tags,
    {
      "Name" = var.name
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}