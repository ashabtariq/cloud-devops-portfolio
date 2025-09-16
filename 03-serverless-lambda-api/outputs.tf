output "tableName" {
  description = "Dynamo DB Table Name"
  value       = aws_dynamodb_table.url_shortner_terra.name
}