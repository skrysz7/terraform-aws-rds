output "db_option_group_id" {
  description = "The db option group id"
  value       = try(aws_db_option_group.this.id, null)
}

output "db_option_group_arn" {
  description = "The ARN of the db option group"
  value       = try(aws_db_option_group.this.arn, null)
}
output "db_option_group_name" {
  description = "The name of the DB option group"
  value       = try(aws_db_option_group.this.name, null)
}