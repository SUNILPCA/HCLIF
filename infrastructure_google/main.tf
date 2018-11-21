module "blueprint" {	
	source = "./blueprint/webserver"
	application = "${var.application}"
	environment = "${var.environment}"
	
}
