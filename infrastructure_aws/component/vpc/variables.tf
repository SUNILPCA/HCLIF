variable "application" {}
variable "environment" {}
variable "aws_region" {}
variable "instance_tenancy" {}
variable "enable_dns_hostnames" {}
variable "enable_dns_support" {}
variable "assign_generated_ipv6_cidr_block" {}
variable "cidr_block" {}
variable "amount_subnets" {}
variable "private_subnets_cidr_block" {
	type = "list"
}
variable public_subnets_cidr_block {
	type = "list"
}
variable "subnets" {
	default = {
		"0" = "a"
		"1" = "b"
		"2" = "c"
		"3" = "d"
	}
}