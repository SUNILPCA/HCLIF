variable "application" {
  description = "Application name used for tagging AZURE resources"
  default     = "terraform-poc"
}
variable "client_id" {}
variable "client_secret" {}
variable "environment" {
  description = "the name of the environment for infra deployment on AZURE account"
  default = "dev"
}
variable "subscription_id" {}
variable "tenant_id" {}