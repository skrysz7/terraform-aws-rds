data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_secretsmanager_secret" "this" {
  arn = aws_db_instance.this.db_instance_master_user_secret_arn
  #depends_on = [aws_db_instance.this]
}