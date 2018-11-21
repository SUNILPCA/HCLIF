resource "random_integer" "ri" {
	min = "${var.random_integer_min}"
	max = "${var.random_integer_max}"
}

resource "azurerm_app_service_plan" app_service_plan {
	name 				= "${var.application}-tfex-appservice-${random_integer.ri.result}-plan"
	location			= "${var.location}"
	resource_group_name = "${var.resource_group_name}"
	
	sku {
		tier = "${var.app_service_plan_sku_tier}"
		size = "${var.app_service_plan_sku_size}"
	}	
}

resource "azurerm_app_service" app_service {
	name				= "${var.application}-tfex-appservice-${random_integer.ri.result}"
	location 			= "${var.location}"
	resource_group_name	= "${var.resource_group_name}"
	app_service_plan_id	= "${azurerm_app_service_plan.app_service_plan.id}"
	
	site_config {
		dotnet_framework_version = "${var.dotnet_framework_version}"
		remote_debugging_enabled = "${var.remote_debugging_enabled}"
		remote_debugging_version = "${var.remote_debugging_version}"
	}
}

output "app_service_name" {
	value = "${azurerm_app_service.app_service.name}"
}

output "app_service_default_hostname" {
	value = "https://${azurerm_app_service.app_service.default_site_hostname}"
}