module "blueprint" {
	source = "./blueprint/webserver"
  
	application 	= "${var.application}"
	environment 	= "${var.environment}"
	subscription_id = "${var.subscription_id}"
}
