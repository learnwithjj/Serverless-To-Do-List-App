resource "aws_dynamodb_table" "todolisttable" {
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  name           = "${var.environment}-todolisttable"
  stream_enabled = false

}
