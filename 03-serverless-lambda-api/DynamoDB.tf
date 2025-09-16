    resource "aws_dynamodb_table" "url_shortner_terra" {
      name             = var.tableName
      billing_mode     = "PAY_PER_REQUEST" # or "PROVISIONED"
      hash_key         = "short_code"

      attribute {
        name = "short_code"
        type = "S" # String type
      }

      tags = {
        Environment = var.environment
        Name = var.tableName

      }
    }