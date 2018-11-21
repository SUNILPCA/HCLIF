variable "application" {}
variable "environment" {}
variable "amis" {}
variable "instance_type" {}
variable "server_port" {}
variable webserver_availability_zones {
	description = "List of availability zones"
	type        = "list"
}
