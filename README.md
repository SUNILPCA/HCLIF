# Terraform POC 
The design was to develop a solution or framework (HCLIF – Hitachi Cloud Infrastructure) which would create the infrastructure irrespective of the underlying cloud service. AWS/Google Cloud/Azure (POC for AWS Provider).

# Basic requirments
* terraform installed
* nodejs installed
* update the terraform.tfvars with provider's (aws) access_key and secret_key

# Steps to Execute:
* At root folder - npm install
* To create infrastructure - node index.js
* To destroy infrastructure - node destroy.js 
* Resources at aws console -
	- EC2 instance for t2.micro
	- IAM role for lambda 
	    - Policy to lambda to access dynamoDB
	- DynamoDB
	- S3 bucket
	- Lambda function
