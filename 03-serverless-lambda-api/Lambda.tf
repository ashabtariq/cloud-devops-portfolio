data "archive_file" "lambda_DeploymentPackage" {
  type = "zip"

  source_dir  = "${path.module}/lambda/"
  output_path = "${path.module}/lambda/deployment_package.zip"
}

# LAMBDA FUNCTION
resource "aws_lambda_function" "terraform_lambda" {
  function_name = var.functionName
  handler = "lambda_function.lambda_handler"
  runtime = "python3.10"
  role          = var.lambdaRole
  filename         = data.archive_file.lambda_DeploymentPackage.output_path
  source_code_hash = data.archive_file.lambda_DeploymentPackage.output_base64sha256
  memory_size   = 256
  timeout       = 30
}