resource "aws_apigatewayv2_api" "todoapi" {
  name          = "${var.environment}-ToDoApi"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "todoint" {
  api_id             = aws_apigatewayv2_api.todoapi.id
  integration_type   = "AWS_PROXY"
  description        = "Lambda crud"
  integration_method = "POST"
  integration_uri    = data.aws_lambda_function.crud-lambda.invoke_arn
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

resource "aws_apigatewayv2_stage" "todo" {
  api_id = aws_apigatewayv2_api.todoapi.id
  name   = "${var.environment}-todo"
  access_log_settings  {
    destination_arn = aws_cloudwatch_log_group.api.arn
    format = jsonencode({
      "method" : "$context.httpMethod",
      "path" : "$context.resourcePath",
      "query" : "$input.params().querystring",
      "headers" : "$input.params().header",
      "body" : "#if($input.body != '') $input.body #else null #end"
      }
    )
  }
  tags = {
    "ENVIRONMENT"    = "var.environment"
    "DEPLOYED-USING" = "GITHUB ACTIONS"
  }
}

resource "aws_apigatewayv2_deployment" "todo" {
  api_id      = aws_apigatewayv2_api.todoapi.id
  description = "${var.environment}-deployment"
  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_integration.todoint),
      jsonencode(aws_apigatewayv2_route.POST),
      jsonencode(aws_apigatewayv2_route.PUT),
      jsonencode(aws_apigatewayv2_route.DELETE),
      jsonencode(aws_apigatewayv2_route.GET),
    ])))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "api" {
  name = "${var.environment}/aws/apigateway"
  tags = {
    Environment = "${var.environment}"
    Application = "apigateway"
  }
  retention_in_days = 3
}

