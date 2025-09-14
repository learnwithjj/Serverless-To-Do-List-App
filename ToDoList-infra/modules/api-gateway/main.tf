resource "aws_apigatewayv2_api" "todoapi" {
  name          = "${var.environment}-ToDoApi"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "todoint" {
  api_id                    = aws_apigatewayv2_api.todoapi.id
  integration_type          = "AWS_PROXY"
  description               = "Lambda crud"
  integration_method        = "POST"
  integration_uri           = data.aws_lambda_function.crud-lambda.invoke_arn
}

resource "aws_apigatewayv2_route" "POST" {
  api_id    = aws_apigatewayv2_api.todoapi.id
  route_key = "POST /task"
  target    = "integrations/${aws_apigatewayv2_integration.todoint.id}"
}

resource "aws_apigatewayv2_route" "GET" {
  api_id    = aws_apigatewayv2_api.todoapi.id
  route_key = "GET /task"
  target    = "integrations/${aws_apigatewayv2_integration.todoint.id}"
}

resource "aws_apigatewayv2_route" "DELETE" {
  api_id    = aws_apigatewayv2_api.todoapi.id
  route_key = "DELETE /task/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.todoint.id}"
}

resource "aws_apigatewayv2_route" "PUT" {
  api_id    = aws_apigatewayv2_api.todoapi.id
  route_key = "PUT /task/{id}"
  target    = "integrations/${aws_apigatewayv2_integration.todoint.id}"
}

resource "aws_apigatewayv2_stage" "example" {
  api_id      = aws_apigatewayv2_api.todoapi.id
  name        = "${var.environment}-todo"
  auto_deploy = true
  tags = {
    "ENVIRONMENT"    = "var.environment"
    "DEPLOYED-USING" = "GITHUB ACTIONS"
  }
}


