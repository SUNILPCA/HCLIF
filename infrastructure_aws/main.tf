locals {
	selectedBluePrint = "${lookup(var.blueprint, var.blueprint_key)}"
}
module "blueprint" {
	count = "${local.selectedBluePrint}"
	source = "./blueprint/staticwebsite"
  
	environment = "${var.environment}-server"
	access_key = "${var.access_key}"
	secret_key = "${var.secret_key}"
}
