# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 	BASIC WEB APPLICATION HOSTING ON AZURE:- 
#	1. AZURE DSN
#	2. App Service web app
#	3. App Service Plan
#	4. Storage Blob 
#	6. AZURE SQL Database
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

module "resource_group" {
	source 								= "../../component/resource_group"
	application							= "${var.application}"
	environment 						= "${var.environment}"
	
	location							= "${var.location}"
}
module "rds" {
	source 								= "../../component/rds"
	application							= "${var.application}"
	environment 						= "${var.environment}"
	
	resource_group_name              	= "${module.resource_group.resource_group_name}"
	location							= "${var.location}"
	edition                          	= "${var.edition}"
	collation                        	= "${var.collation}"
	create_mode                      	= "${var.create_mode}"
	requested_service_objective_name 	= "${var.requested_service_objective_name}"
	#version								= "${var.version}"
	sql_admin          					= "${var.sql_admin}"
	sql_password				 		= "${var.sql_password}"	
	start_ip_address    				= "${var.start_ip_address}"
	end_ip_address      				= "${var.end_ip_address}"
}
module "app_service" {
	source								= "../../component/app_service"
	application							= "${var.application}"
	environment							= "${var.environment}"
	
	app_service_plan_sku_tier			= "${var.app_service_plan_sku_tier}"
	app_service_plan_sku_size			= "${var.app_service_plan_sku_size}"
	dotnet_framework_version			= "${var.dotnet_framework_version}"
	location							= "${module.resource_group.resource_group_location}"
	resource_group_name					= "${module.resource_group.resource_group_name}"	
	random_integer_max					= "${var.random_integer_max}"
	random_integer_min					= "${var.random_integer_min}"	
	remote_debugging_enabled			= "${var.remote_debugging_enabled}"
	remote_debugging_version			= "${var.remote_debugging_version}"
}
module "storage_blob" {
	source								= "../../component/storage_blob"
	application							= "${var.application}"
	environment							= "${var.environment}"
	
	resource_group_name              	= "${module.resource_group.resource_group_name}"
	location							= "${var.location}"
	account_tier						= "${var.account_tier}"
	account_replication_type			= "${var.account_replication_type}"
	container_access_type				= "${var.container_access_type}"
	type								= "${var.type}"
	size								= "${var.size}"
}