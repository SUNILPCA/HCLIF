resource"aws_dynamodb_table" "table" {
  name            = "${var.application}_table"
  read_capacity    = 10
  write_capacity  = 10
  hash_key 	  ="clientId"

  attribute {
    name = "clientId"
    type=  "N"
  }
}