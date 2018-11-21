resource "azurerm_storage_account" "account" {
	name                     = "${var.application}account"
	resource_group_name      = "${var.resource_group_name}"
	location                 = "${var.location}"
	account_tier             = "${var.account_tier}"
	account_replication_type = "${var.account_replication_type}"
}

resource "azurerm_storage_container" "container" {
	name                  = "${var.application}-vhds"
	resource_group_name   = "${var.resource_group_name}"
	storage_account_name  = "${azurerm_storage_account.account.name}"
	container_access_type = "${var.container_access_type}"
}

resource "azurerm_storage_blob" "storage_blob" {
	name = "${var.application}.vhd"
	resource_group_name    = "${var.resource_group_name}"
	storage_account_name   = "${azurerm_storage_account.account.name}"
	storage_container_name = "${azurerm_storage_container.container.name}"

	type = "${var.type}"
	size = 1024
}