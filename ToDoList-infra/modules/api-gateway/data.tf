data "aws_lambda_function" "crud-lambda" {
  function_name = "${var.environment}-crudtodolist"
}

