output "s3_bucket_name" {
  description = "Name of the s3 bucket"
  value       = aws_s3_bucket.terraform_state.arn
}

output "dynamodb_locktable_tame" {
  description = "The name of the DynamoDB Lock table"
  value       = aws_dynamodb_table.terraform_locks.name
}
