# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 	WEB APPLICATION HOSTING ON AWS:- 
#	1. Route 53
#	2. CloudFront
#	3. S3 - For resource and static content
#	4. Amazon EC2 
#	6. Elastic Load Balancing
#	5. Auto Scaling (Webserver / Application Server) 
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# ---------------------------------------------------------------------------------------------------------------------
# GET THE LIST OF AVAILABILITY ZONES IN THE CURRENT REGION
# Every AWS accout has slightly different availability zones in each region. For example, one account might have
# us-east-1a, us-east-1b, and us-east-1c, while another will have us-east-1a, us-east-1b, and us-east-1d. This resource
# queries AWS to fetch the list for the current account and region.
# ---------------------------------------------------------------------------------------------------------------------

data "aws_availability_zones" "all" {}
module "launch_configurations_web" {
	source 							= "../../component/launch_configurations"
	application						= "${var.application}"
	environment 					= "${var.environment}"
	webserver_security_group_id 	= ["${module.web_instances.webserver_security_group_id}"]
	amis							= "${var.amis}"
	instance_type					= "${var.instance_type}"
	server_port						= "${var.server_port}"
	user_data						= "${file("./component/user_data/user_data_webserver.sh")}"
}
module "launch_configurations_app" {
	source 							= "../../component/launch_configurations"
	application						= "${var.application}"
	environment 					= "${var.environment}"
	webserver_security_group_id 	= ["${module.app_instances.webserver_security_group_id}"]
	amis							= "${var.amis}"
	instance_type					= "${var.instance_type}"
	server_port						= "${var.server_port}"
	user_data						= "${file("./component/user_data/user_data_appserver.sh")}"
}
module "load_balancers" {
	source 							= "../../component/load_balancers"
	application						= "${var.application}"
	environment 					= "${var.environment}"
	webserver_availability_zones 	= ["${data.aws_availability_zones.all.names}"]
	amis							= "${var.amis}"
	instance_type					= "${var.instance_type}"
	server_port						= "${var.server_port}"
}
module "autoscaling_groups_web" {
	source 							= "../../component/autoscaling_groups"
	application						= "${var.application}"
	environment 					= "${var.environment}-web"
	webserver_lc_id 				= "${module.launch_configurations_web.webserver_lc_id}"
	webserver_availability_zones 	= ["${data.aws_availability_zones.all.names}"]
	webserver_elb_name 				= "${module.load_balancers.webserver_elb_name}" 
	amis							= "${var.amis}"
	instance_type					= "${var.instance_type}"
	server_port						= "${var.server_port}"
	asg_max							= "${var.asg_max}"
	asg_min							= "${var.asg_min}"
	
}
module "autoscaling_groups_app" {
	source 							= "../../component/autoscaling_groups"
	application						= "${var.application}"
	environment 					= "${var.environment}-app"
	webserver_lc_id 				= "${module.launch_configurations_app.webserver_lc_id}"
	webserver_availability_zones 	= ["${data.aws_availability_zones.all.names}"]
	webserver_elb_name 				= "${module.load_balancers.webserver_elb_name}" 
	amis							= "${var.amis}"
	instance_type					= "${var.instance_type}"
	server_port						= "${var.server_port}"
	asg_max							= "${var.asg_max}"
	asg_min							= "${var.asg_min}"
	
}
module "web_instances" {
	source 							= "../../component/instances"
	application						= "${var.application}"
	environment 					= "${var.environment}_webserver"
	amis							= "${var.amis}"
	instance_type					= "${var.instance_type}"
	server_port						= "${var.server_port}"
	#webserve_sg_id					= ["${module.vpc.webserve_sg_id}"]
	key_name 						= "${var.key_name}"
	user_data						= "${file("./component/user_data/user_data_webserver.sh")}"
}
module "app_instances" {
	source 							= "../../component/instances"
	application						= "${var.application}"
	environment 					= "${var.environment}_appserver"
	amis							= "${var.amis}"
	instance_type					= "${var.instance_type}"
	server_port						= "${var.server_port}"
	#webserve_sg_id					= ["${module.vpc.webserve_sg_id}"]
	key_name 						= "${var.key_name}"
	user_data						= "${file("./component/user_data/user_data_appserver.sh")}"
}
module "s3" {
	source 							= "../../component/s3"
	application						= "${var.application}"
	environment 					= "${var.environment}"
	domain_name						= "${var.domain_name}"
}
module "route53" {
	source								= "../../component/route53"
	application							= "${var.application}"
	environment 						= "${var.environment}"
	domain_name							= "${var.domain_name}"
	cloudfront_website_domain_name 		= "${module.cloud_front.cloudfront_website_domain_name}"
	cloudfront_website_hosted_zone 		= "${module.cloud_front.cloudfront_website_apex_hosted_zone}"
	cloudfront_website_apex_domain_name = "${module.cloud_front.cloudfront_website_apex_domain_name}"
	cloudfront_website_apex_hosted_zone = "${module.cloud_front.cloudfront_website_apex_hosted_zone}"
}
module "cloud_front" {
	source 							= "../../component/cloud_front"
	application						= "${var.application}"
	environment 					= "${var.environment}"
	domain_name						= "${var.domain_name}"
	enabled							= "${var.enabled}"
	is_ipv6_enabled					= "${var.is_ipv6_enabled}"
	restriction_type				= "${var.restriction_type}"
	website_bucket_domain_name 		= "${module.s3.website_bucket_domain_name}"
	website_apex_bucket_domain_name = "${module.s3.website_apex_bucket_domain_name}"
}
module "rds" {
	source 							= "../../component/rds"
	application						= "${var.application}"
	environment 					= "${var.environment}"
	vpc_id          				= "${module.vpc.vpc_id}"
	subnets         				= ["${module.vpc.private_subnets_id}"]
	size            				= "${var.size}"	
	rds_password    				= "${var.rds_password}"
	multi_az        				= "${var.multi_az}"
	name							= "${var.name}"
	tag								= "${var.tag}"
	security_groups					= "${var.security_groups}"
	vpc_security_groups				= ["${module.vpc.dbserver_sg_id}"]
	allowed_cidr_blocks				= "${var.allowed_cidr_blocks}"
	default_ports					= "${var.default_ports}"
	engine							= "${var.engine}"
	default_parameter_group_family	= "${var.default_parameter_group_family}"
	default_db_parameters			= "${var.default_db_parameters}"
	storage							= "${var.storage}"
	engine_version					= "${var.engine_version}"
	storage_type					= "${var.storage_type}"
	rds_username					= "${var.rds_username}"
	rds_custom_parameter_group_name	= "${var.rds_custom_parameter_group_name}"
	backup_retention_period   		= "${var.backup_retention_period}"
	storage_encrypted         		= "${var.storage_encrypted}"
	apply_immediately         		= "${var.apply_immediately}"
	skip_final_snapshot       		= "${var.skip_final_snapshot}"
	availability_zone         		= "${var.availability_zone}"
	snapshot_identifier       		= "${var.snapshot_identifier}"
	number							= "{var.number}"
}
module "vpc" {
	source 							= "../../component/vpc"
	application						= "${var.application}"
	environment 					= "${var.environment}"
	cidr_block 						= "${var.cidr_block}"	
	private_subnets_cidr_block 		= ["${var.private_subnets_cidr_block}"]
	public_subnets_cidr_block		= ["${var.public_subnets_cidr_block}"]
	instance_tenancy                = "${var.instance_tenancy}"
	enable_dns_hostnames            = "${var.enable_dns_hostnames}"
	enable_dns_support              = "${var.enable_dns_support}"
	assign_generated_ipv6_cidr_block= "${var.assign_generated_ipv6_cidr_block}"
	amount_subnets					= "${var.amount_subnets}"
	subnets							= "${var.subnets}"
	aws_region						= "${var.aws_region}"
}