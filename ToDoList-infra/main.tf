module "api-gateway" {
  source      = "./modules/api-gateway"
  environment = var.environment
  depends_on  = [module.lambda]
}

module "dynamodb" {
  source      = "./modules/dynamodb"
  environment = var.environment
}

#module "eventbridge" {
#  source = "./modules/eventbridge"
#}

module "lambda" {
  source          = "./modules/lambda"
  environment     = var.environment
  lambda_iam_role = aws_iam_role.lambda_role.arn
  region          = var.region
  depends_on      = [module.dynamodb]
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.environment}-todolist_lambda_policy"
  path        = "/"
  description = "My to do list lambda policy"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Dynamodb",
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:PutItem",
            "dynamodb:Scan",
            "dynamodb:GetItem",
            "dynamodb:DeleteItem",
            "dynamodb:UpdateItem"
          ],
          "Resource" : "arn:aws:dynamodb:${var.region}:${data.aws_caller_identity.current.account_id}:table/${var.environment}-todolisttable"
        },
        {
          "Sid" : "SES",
          "Effect" : "Allow",
          "Action" : [
            "ses:SendEmail"
          ],
          "Resource" : "*"
        }
      ]
    }
  )
}


resource "aws_iam_role" "lambda_role" {
  name               = "${var.environment}-todolist_lambda_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy_attachment" "lambda-policy-attach" {
  name       = "${var.environment}-todolist_lambda_policy_attachment"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = aws_iam_policy.lambda_policy.arn
}
