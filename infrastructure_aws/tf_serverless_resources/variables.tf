variable "environment" {
  description = "the name of the environment for infra deployment on AWS account"
  default = "terraform-poc"
}
variable "application" {
  description = "Application name used for tagging AWS resources"
  default     = "Data Pipeline"
}
variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-west-2"
}
