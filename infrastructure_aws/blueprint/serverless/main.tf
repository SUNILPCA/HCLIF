# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 	SERVLERLESS HOSTING ON AWS:- 
#	1. API Gateway
#	2. DynamoDB
#	3. POST/GET Lambda Function
#	4. SNS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#module "apigateway" {
#	source 		= "../../component/api_gateway"
#	count 		= "${var.count}"
#	environment = "${var.environment}"
#}
#module "lambdafunction" {
#	source 		= '../../component/lambda_function'
#	count 		= "${var.count}"
#	environment = "${var.environment}"
#}
module "dynamodb" {
	source 		= "../../component/dynamo_db"
	count 		= "${var.count}"
	environment = "${var.environment}"
}
module "sns" {
	source 		= "../../component/sns"
	count 		= "${var.count}"
	environment = "${var.environment}"
}