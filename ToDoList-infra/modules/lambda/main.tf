data "archive_file" "lambda_function_crud" {
  type        = "zip"
  source_file = "script/crud.py"
  output_path = "script/crud.zip"
}

resource "aws_lambda_function" "crud" {
  filename         = data.archive_file.lambda_function_crud.output_path
  function_name    = "${var.environment}-crudtodolist"
  role             = var.lambda_iam_role
  handler          = "lambda_function.lambda_handler"
  source_code_hash = data.archive_file.lambda_function_crud.output_base64sha256
  runtime          = "python3.13"
  environment {
    variables = {
      REGION      = "${var.region}"
      TASKS_TABLE = "${var.environment}-todolisttable"
    }
  }
}

