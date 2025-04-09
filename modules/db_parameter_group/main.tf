resource "aws_db_parameter_group" "this" {
  count = var.create ? 1 : 0

  name        = local.name
  name_prefix = var.name_prefix
  description = local.parameter_group_description
  family      = local.family

  # dynamic "parameter" {
  #   for_each = local.all_parameters
  #   content {
  #     name         = parameter.value.name
  #     value        = parameter.value.value
  #     apply_method = lookup(parameter.value, "apply_method", null)
  #   }
  # }
  dynamic "parameter" {
    for_each = local.merged_parameters
    content {
      name         = parameter.value.name
      value        = parameter.value.value
      apply_method = parameter.value.apply_method
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