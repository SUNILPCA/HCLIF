# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 	SERVLERLESS HOSTING ON AWS:- 
#	1. API Gateway
#	2. DynamoDB
#	3. POST/GET Lambda Function
#	4. SNS
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#module "apigateway" {
#	source 		= "../../component/api_gateway"
#	application	= "${var.application}"
#	environment = "${var.environment}"
#}
#module "lambdafunction" {
#	source 		= '../../component/lambda_function'
#	application = "${var.application}"
#	environment = "${var.environment}"
#}
module "dynamodb" {
	source 		= "../../component/dynamo_db"
	application = "${var.application}"
	environment = "${var.environment}"
}
module "sns" {
	source 		= "../../component/sns"
	application = "${var.application}"
	environment = "${var.environment}"
}