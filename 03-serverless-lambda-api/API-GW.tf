resource "aws_api_gateway_rest_api" "url_shortner_api" {
  name        = "url_shortner_api"
  description = "URL Shortner API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

#ROOT PATH:  When this configuration is provisioned, the resource will be accessible at “<URL>/mypath”. “mypath” is the path name
resource "aws_api_gateway_resource" "shorten_resource" {
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
  parent_id   = aws_api_gateway_rest_api.url_shortner_api.root_resource_id
  path_part   = "shorten"
}


resource "aws_api_gateway_method" "shorten_post" {
  rest_api_id    = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id    = aws_api_gateway_resource.shorten_resource.id
  http_method    = "POST"
  authorization  = "NONE"
  request_models = {}
}


# Lambda integration
resource "aws_api_gateway_integration" "shorten_post_integration" {
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id = aws_api_gateway_resource.shorten_resource.id
  http_method = aws_api_gateway_method.shorten_post.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.terraform_lambda.invoke_arn
}


# Give API Gateway permission to invoke Lambda
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.url_shortner_api.execution_arn}/*/*"
}

# Deployment
resource "aws_api_gateway_deployment" "shorten_api_deploy" {
  depends_on  = [aws_api_gateway_integration.shorten_post_integration]
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.shorten_api_deploy.id
  rest_api_id   = aws_api_gateway_rest_api.url_shortner_api.id
  stage_name    = "prod"

}

output "invoke_url" {
  value = aws_api_gateway_stage.prod.invoke_url

}
