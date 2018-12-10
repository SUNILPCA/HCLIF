module "blueprint" {
	source = "./blueprint/webserver"
  
	application 	= "${var.application}"
	environment 	= "${var.environment}"
	access_key 		= "${var.access_key}"
	secret_key 		= "${var.secret_key}"
}
