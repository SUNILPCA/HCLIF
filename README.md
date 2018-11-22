# Terraform POC 
The design was to develop a solution or framework (HCLIF – Hitachi Cloud Infrastructure) which would create the infrastructure irrespective of the underlying cloud service. AWS/Google Cloud/Azure.

# Basic requirments
* terraform installed
* nodejs installed
* create/update the terraform.tfvars with provider's info like below :-
	- (aws) access_key="" and secret_key=""
	- (azure) 	subscription_id = ""
				client_id = ""
				client_secret = ""
				tenant_id = ""
	- (google)	project_id = "" (default project_id) and download the user credential (JSON) file.

# Steps to Execute:
* At root folder - npm install
* To create/destory infrastructure - node index.js
* Available Buildprnts -
	- AWS : webserver (https://media.amazonwebservices.com/architecturecenter/AWS_ac_ra_web_01.pdf), serverless
	- AZURE : webserver (https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/basic-web-app)
	- GCP : webserver (https://gcp.solutions/diagram/Dynamic%20Hosting)
