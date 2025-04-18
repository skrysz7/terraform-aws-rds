output "db_parameter_group_id" {
  description = "The db parameter group id"
  value       = try(aws_db_parameter_group.this.id, null)
}

output "db_parameter_group_arn" {
  description = "The ARN of the db parameter group"
  value       = try(aws_db_parameter_group.this.arn, null)
}
output "db_parameter_group_name" {
  description = "The name of the DB parameter group"
  value       = try(aws_db_parameter_group.this.name, null)
}