resource "azurerm_sql_database" "db" {
	name 								= "${var.application}-db"
	resource_group_name         		= "${var.resource_group_name}"
	location							= "${var.location}"
	edition								= "${var.edition}"
	collation							= "${var.collation}"
	create_mode							= "${var.create_mode}"
	requested_service_objective_name	= "${var.requested_service_objective_name}"
	server_name							= "${azurerm_sql_server.server.name}"
}
resource "azurerm_sql_server" "server" {
	name                         		= "${var.application}-sqlsvr"
	resource_group_name          		= "${var.resource_group_name}"
	location                     		= "${var.location}"
	version                      		= "12.0"
	administrator_login          		= "${var.sql_admin}"
	administrator_login_password 		= "${var.sql_password}"
}

# Enables the "Allow Access to Azure services" box as described in the API docs 
# https://docs.microsoft.com/en-us/rest/api/sql/firewallrules/createorupdate
resource "azurerm_sql_firewall_rule" "fw" {
	name                				= "${var.application}-fw"
	resource_group_name 				= "${var.resource_group_name}"
	server_name         				= "${azurerm_sql_server.server.name}"
	start_ip_address    				= "${var.start_ip_address}"
	end_ip_address						= "${var.end_ip_address}"
}