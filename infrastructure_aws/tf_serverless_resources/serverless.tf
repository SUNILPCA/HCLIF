resource "aws_iam_role" "iam_for_lambda" {
  name = "${var.environment}-iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda.zip"
  function_name    = "${var.environment}-lambda"
  role             = "${aws_iam_role.iam_for_lambda.arn}"
  handler          = "index.handler"
  source_code_hash = "${base64sha256(file("lambda.zip"))}"
  runtime          = "nodejs4.3"
  
  environment {
    variables = {
      foo = "bar"
    }
  }
}

resource "aws_iam_role_policy" "insert-policy" {
  name = "${var.environment}-demo-data-persist"
  role = "${aws_iam_role.iam_for_lambda.id}"

  policy =<<EOF
{
  "Version": "2012-10-17",
  "Statement":[
    {
       "Effect": "Allow",
       "Action":["dynamodb:PutItem", "dynamodb:BatchWriteItem", "dynamodb:Query", "dynamodb:UpdateItem"],
       "Resource":"*"
    }
  ]
}
EOF
}