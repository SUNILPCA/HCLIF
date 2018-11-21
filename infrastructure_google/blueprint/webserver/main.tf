# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 	BASIC WEB APPLICATION HOSTING ON Google Cloud Platform:- 
#	1. Google VM Instance 
#	2. Google Instance Group
#	3.  
#	4.   
#	6.  
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

data "google_compute_zones" "available" {}

module "instance_www" {
	source 					= "../../component/instance"
	application				= "${var.application}-www-compute"
	environment 			= "${var.environment}"
	
	machine_type			= "${var.machine_type}"
	tag						= "${var.tag}"
	image					= "${var.image}"
	metadata_startup_script = "${file("./component/scripts/install-www.sh")}"
}
module "instance_www_video" {
	source 					= "../../component/instance"
	application				= "${var.application}-video-compute"
	environment 			= "${var.environment}"
	
	machine_type			= "${var.machine_type}"
	tag						= "${var.tag}"
	image					= "${var.image}"
	metadata_startup_script = "${file("./component/scripts/install-video.sh")}"
}
module "instance_group_www" {
	source 					= "../../component/instance_group"
	application				= "${var.application}-www-instance"
	environment 			= "${var.environment}"
	
	instance_self_link		= "${module.instance_www.instance_self_link}"
}
module "instance_group_www_video" {
	source 					= "../../component/instance_group"
	application				= "${var.application}-video-instance"
	environment 			= "${var.environment}"
	
	instance_self_link		= "${module.instance_www_video.instance_self_link}"
}
module "http_load_balancer" {
	source 					= "../../component/http_load_balancer"
	application				= "${var.application}"
	environment 			= "${var.environment}"
	
	group_www				= "${module.instance_group_www.instance_group_self_link}"
	group_video				= "${module.instance_group_www_video.instance_group_self_link}"
	
}
module "sql_instance" {
	source 					= "../../component/sql_instance"
	application				= "${var.application}"
	environment 			= "${var.environment}"
	#project_id				= "${var.project_id}" default provider project id
	
	#zone					= ["${data.google_compute_zones.names}"]
	db_charset   			= "${var.db_charset}"
	db_collation 			= "${var.db_collation}"
	user_host  				= "${var.user_host}"
	user_name				= "${var.user_name}"
	user_password			= "${var.user_password}"
	#region					= "${var.region}"
	database_version     	= "${var.database_version}"
	master_instance_name 	= "${var.master_instance_name}"
	tier                    = "${var.tier}"
	activation_policy       = "${var.activation_policy}"
	authorized_gae_applications = ["${var.authorized_gae_applications}"]
	disk_autoresize         = "${var.disk_autoresize}"
	backup_configuration    = ["${var.backup_configuration}"]
	ip_configuration        = ["${var.ip_configuration}"]
	location_preference     = ["${var.location_preference}"]
	maintenance_window      = ["${var.maintenance_window}"]
	disk_size               = "${var.disk_size}"
	disk_type               = "${var.disk_type}"
	pricing_plan            = "${var.pricing_plan}"
	replication_type        = "${var.replication_type}"
	database_flags          = ["${var.database_flags}"]
	replica_configuration	= ["${var.replica_configuration}"]
}
#module "instance_templates" {
#	source 					= "../../component/instance_templates"
#	application				= "${var.application}"
#	environment 			= "${var.environment}"
	
#	machine_type			= "${var.machine_type}"
	#tag					= "${var.tag}"
#	image					= "${var.image}"
#	metadata_startup_script = "${file("./component/scripts/install-www.sh")}"	
#}
#module "instance_group" {
#	source 					= "../../component/instance_group"
#	application				= "${var.application}"
#	environment 			= "${var.environment}"
	
#	zone					= ["${data.google_compute_zones.available.names}"]
#	instance_self_link		= "${module.instance_templates.instance_self_link}"
#}