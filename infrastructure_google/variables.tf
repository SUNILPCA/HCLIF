variable "application" {
	description = "Application name used for tagging Google Cloud resources"
	default     = "terraform-poc"
}
variable "environment" {
	description = "the name of the environment for infra deployment on Google Cloud account"
	default = "dev"
}
variable "project_id" {}
variable "region" {
	#default = "us-central1"
	default = "us-west1"
}
#variable "zone" {
#	default = "us-central1-b"
#}

