resource"aws_dynamodb_table" "table" {
  name            = "${var.environment}-Table"
  read_capacity    = 10
  write_capacity  = 10
  hash_key 	  ="terraformPOCBid"

  attribute {
    name = "terraformPOCBid"
    type=  "S"
  }
}