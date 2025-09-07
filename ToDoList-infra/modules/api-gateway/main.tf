resource "aws_api_gateway_rest_api" "Todolistapi" {
  name        = "${var.environment}-ToDoApi"
  description = "This is my API for todolistapp"
}

resource "aws_api_gateway_resource" "TOdolistresource" {
  rest_api_id = aws_api_gateway_rest_api.Todolistapi.id
  parent_id   = aws_api_gateway_rest_api.Todolistapi.root_resource_id
  path_part   = "${var.environment}-ToDoApiResource"
}

resource "aws_api_gateway_method" "get_method" {
  rest_api_id   = aws_api_gateway_rest_api.Todolistapi.id
  resource_id   = aws_api_gateway_resource.TOdolistresource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.get_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.aws_lambda_function.crud-lambda.invoke_arn
}

resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.Todolistapi.id
  resource_id   = aws_api_gateway_resource.TOdolistresource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.aws_lambda_function.crud-lambda.invoke_arn
}

resource "aws_api_gateway_method" "put_method" {
  rest_api_id   = aws_api_gateway_rest_api.Todolistapi.id
  resource_id   = aws_api_gateway_resource.TOdolistresource.id
  http_method   = "PUT"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "put_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.put_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.aws_lambda_function.crud-lambda.invoke_arn
}

resource "aws_api_gateway_method" "delete_method" {
  rest_api_id   = aws_api_gateway_rest_api.Todolistapi.id
  resource_id   = aws_api_gateway_resource.TOdolistresource.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "delete_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.delete_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = data.aws_lambda_function.crud-lambda.invoke_arn
}


resource "aws_lambda_permission" "apigw_lambda_get" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.crud-lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.Todolistapi.id}/*/${aws_api_gateway_method.get_method.http_method}${aws_api_gateway_resource.TOdolistresource.path}"
}

resource "aws_lambda_permission" "apigw_lambda_create" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.crud-lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.Todolistapi.id}/*/${aws_api_gateway_method.create_method.http_method}${aws_api_gateway_resource.TOdolistresource.path}"
}

resource "aws_lambda_permission" "apigw_lambda_delete" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.crud-lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.Todolistapi.id}/*/${aws_api_gateway_method.delete_method.http_method}${aws_api_gateway_resource.TOdolistresource.path}"
}


resource "aws_lambda_permission" "apigw_lambda_post" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = data.aws_lambda_function.crud-lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.Todolistapi.id}/*/${aws_api_gateway_method.post_method.http_method}${aws_api_gateway_resource.TOdolistresource.path}"
}

