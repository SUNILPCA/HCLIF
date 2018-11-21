variable "application" {}
variable "access_key" {}
variable "secret_key" {}
variable "environment" {}
variable "region" {
  default = "us-west-2"
}

#-------------------------------------------------------------------------
# Global Customized variable, which are used for web application hosting 
# blue print (Web server/Application hosting at EC2 instances)
#-------------------------------------------------------------------------
# EC2 Instance AMI 
variable "amis" {
	description ="Base AMI to launch the instances"
	default = "ami-a0cfeed8" #ami-6cd6f714 earlier used
}

# EC2 Instance type
variable "instance_type" {
	default = "t2.micro"
}

# EC2 Instance running on port
variable "server_port" {
	description = "The port the server will use for HTTP requests"
	default = 8080
}
variable "public_key_path" {
	description = "Enter the path to the SSH Public Key to add to AWS."
	default = "/key_pair/terraform_poc.pem"
}

variable "key_name" {
	description = "Key name for SSHing into EC2"
	default = "terraform_poc"
}

#S3 bucket domain name
variable "domain_name" {
	type = "string"
	default = "terraformpoc.com"
}
# Autoscaling group
variable asg_min {
	default = 2
}

variable asg_max {
	default = 10
}

#Cloud Front Enabled
variable "enabled" {
	default = true
}

#Cloud Front ipv6 enabled
variable "is_ipv6_enabled" {
	default = true
}

#Cloud geo restriction type
variable "restriction_type" {
	default = "none"
}

#RDS Variables
variable "default_db_parameters" {
	default = {
		mysql = [
			{
				name  = "slow_query_log"
				value = "1"
			},
			{
				name  = "long_query_time"
				value = "1"
			},
			{
				name  = "general_log"
				value = "0"
			},
			{
				name  = "log_output"
				value = "FILE"
			},
		]

		postgres = []
		oracle   = []
	}
}

variable "default_ports" {
	default = {
		mysql    = "3306"
		postgres = "5432"
		oracle   = "1521"
	}
}

variable "security_groups" {
	description = "Security groups that are allowed to access the RDS"
	type        = "list"
	default     = []
}

variable "allowed_cidr_blocks" {
	description = "CIDR blocks that are allowed to access the RDS"
	type        = "list"
	default     = []
}

#variable "subnets" {
#	type        = "list"
#	description = "Subnets to deploy in"
#}

variable "storage" {
	description = "How many GBs of space does your database need?"
	default     = "10"
}

variable "size" {
	description = "Instance size"
	default     = "db.t2.small"
}

variable "storage_type" {
	description = "Type of storage you want to use"
	default     = "gp2"
}

variable "rds_password" {
	description = "RDS root password"
	default		= "password"
}

variable "rds_username" {
	description = "RDS root user"
	default     = "root"
}

variable "engine" {
	description = "RDS engine: mysql, oracle, postgres. Defaults to mysql"
	default     = "mysql"
}

variable "engine_version" {
  description = "Engine version to use."
  default     = "5.7.17"
}

variable "default_parameter_group_family" {
	description = "Parameter group family for the default parameter group, according to the chosen engine and engine version. Defaults to mysql5.7"
	default     = "mysql5.7"
}

variable "multi_az" {
	description = "Multi AZ true or false"
	default     = true
}

variable "backup_retention_period" {
	description = "How long do you want to keep RDS backups"
	default     = "14"
}

variable "apply_immediately" {
	description = "Apply changes immediately"
	default     = true
}

variable "storage_encrypted" {
	description = "Encrypt RDS storage"
	default     = true
}

variable "tag" {
	description = "A tag used to identify an RDS in a project that has more than one RDS"
	default     = ""
}

variable "number" {
	description = "number of the database default 01"
	default     = "01"
}

variable "rds_custom_parameter_group_name" {
	description = "A custom parameter group name to attach to the RDS instance. If not provided a default one will be used"
	default     = ""
}

variable "skip_final_snapshot" {
	description = "Skip final snapshot when destroying RDS"
	default     = false
}

variable "availability_zone" {
	description = "The availability zone where you want to launch your instance in"
	default     = ""
}

variable "snapshot_identifier" {
	description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05."
	default     = ""
}

variable "name" {
	description = "The name of the RDS instance"
	default = ""
}

#VPC Variables
variable "aws_region" {
	description = "The AWS region to work in."
	default = "us-west-2"
}
variable "instance_tenancy" {
	description = "A tenancy option for instances launched into the VPC"
	default     = "default"
}
variable "enable_dns_hostnames" {
	description = "Should be true to enable DNS hostnames in the VPC"
	default     = true
}
variable "enable_dns_support" {
	description = "Should be true to enable DNS support in the VPC"
	default     = true
}
variable "assign_generated_ipv6_cidr_block" {
	description = "Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block"
	default     = false
}
variable "cidr_block" {
	description = "CIDR block you want to have in your VPC"
	default = "172.31.0.0/16"
}
variable "amount_subnets" {
	description = "Amount of subnets you need"
	default = "3"
}
variable "private_subnets_cidr_block" {
	description = "CIDR Block for Private Subnets that you need, this needs to be , delimited"
	type = "list"
	default =  ["172.31.48.0/20","172.31.64.0/20","172.31.80.0/20","172.31.96.0/20"]
}
variable "public_subnets_cidr_block" {
	description = "CIDR Block for Public Subnets that you need, this needs to be , delimited"
	type = "list"
	default =  ["172.31.112.0/20","172.31.128.0/20","172.31.144.0/20","172.31.160.0/20"]
}
variable "subnets" {
	description = "Availability zones"
	default = {
		"0" = "a"
		"1" = "b"
		"2" = "c"
		"3" = "d"
	}
}