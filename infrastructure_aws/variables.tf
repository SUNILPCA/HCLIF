variable "application" {
  description = "Application name used for tagging AWS resources"
  default     = "Data Pipeline"
}
variable "access_key" {}
variable "environment" {
  description = "the name of the environment for infra deployment on AWS account"
  default = "terraform-poc"
}
variable "region" {
  default = "us-west-2"
}
variable "secret_key" {}

variable "blueprint" {
	type="map"
}
variable "blueprint_key" {}
variable "count" {
	default = "0"
}