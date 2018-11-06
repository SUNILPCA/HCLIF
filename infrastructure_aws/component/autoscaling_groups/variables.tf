variable "environment" {}
variable "count" {}
variable "amis" {}
variable "instance_type" {}
variable "server_port" {}
variable asg_min {}
variable asg_max {}
variable webserver_lc_id {}
variable webserver_elb_name {}
variable webserver_availability_zones {
	description = "List of availability zones"
	type        = "list"
}