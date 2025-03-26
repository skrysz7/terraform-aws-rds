locals {
  # identifier = (
  #   var.app_alias != "" ? 
  #   "db-${lower(var.db_engine)}-${lower(var.app_alias)}-${lower(var.environment)}" : 
  #   "db-${lower(var.db_engine)}-${var.id}-${lower(var.environment)}"
  # )
}
