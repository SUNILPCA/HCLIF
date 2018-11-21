variable "application" {}
variable "environment" {}
variable "amis" {}
variable "instance_type" {}
variable "server_port" {}
variable webserver_security_group_id {
	description = "List of security group id"
	type        = "list"
}
variable "user_data" {}