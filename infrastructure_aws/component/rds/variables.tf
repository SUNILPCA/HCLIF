variable "application" {}
variable "environment" {}
variable "vpc_id" {}
variable "security_groups" {
	type = "list"
}
variable "allowed_cidr_blocks" {
	type = "list"
}
variable "subnets" {
	type = "list"
}
variable "storage" {}
variable "size" {}
variable "storage_type" {}
variable "rds_password" {}
variable "rds_username" {}
variable "engine" {}
variable "engine_version" {}
variable "default_parameter_group_family" {}
variable "multi_az" {}
variable "backup_retention_period" {}
variable "apply_immediately" {}
variable "storage_encrypted" {}
variable "tag" {}
variable "number" {}
variable "rds_custom_parameter_group_name" {}
variable "skip_final_snapshot" {}
variable "availability_zone" {}
variable "snapshot_identifier" {}
variable "name" {}
variable "default_db_parameters" {
	default = {}
}
variable "default_ports" {
	default = {}
}
variable "vpc_security_groups" {
	type = "list"
}