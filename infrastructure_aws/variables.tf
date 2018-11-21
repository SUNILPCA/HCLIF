variable "application" {
	description = "Application name used for tagging AWS resources"
	default     = "terraform-poc"
}
variable "access_key" {}
variable "region" {
	default = "us-west-2"
}
variable "environment" {
	description = "the name of the environment for infra deployment on AWS account"
	default = "dev"
}
variable "secret_key" {}
