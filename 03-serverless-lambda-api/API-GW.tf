resource "aws_api_gateway_rest_api" "url_shortner_api" {
  name = "url_shortner_api"
  description = "URL Shortner API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


#ROOT PATH:  When this configuration is provisioned, the resource will be accessible at “<URL>/mypath”. “mypath” is the path name
resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
  parent_id = aws_api_gateway_rest_api.url_shortner_api.root_resource_id
  path_part = "/"
}


resource "aws_api_gateway_method" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = "POST"
  authorization = "NONE"
}


resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.url_shortner_api.id
  resource_id = aws_api_gateway_resource.root.id
  http_method = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"
  type = "MOCK"
}

