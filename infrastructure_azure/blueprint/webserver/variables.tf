variable "account_tier" {
	default = "Standard"
}						
variable "account_replication_type" {
	default = "LRS"
}
variable "application" {}
variable "app_service_plan_sku_size" {
	type        = "string"
	description = "SKU size of the App Service Plan"
	default     = "B1"                               # B1 | S1 | ...
}
variable "app_service_plan_sku_tier" {
	type        = "string"
	description = "SKU tier of the App Service Plan"
	default     = "Basic"                            # Basic | Standard | ...
}
variable collation {
	default = "SQL_Latin1_General_CP1_CI_AS"
}
variable "container_access_type" {
	default = "private"
}
variable create_mode {
	default = "Default"
}
variable "dotnet_framework_version" {
	default = "v4.0"
}
variable "edition" {
	default = "Basic"
}
variable end_ip_address {
	default = "0.0.0.0"
}
variable "environment" {}
variable "location" {
	description = "The location/region where the SQL Server is created. Changing this forces a new resource to be created."
	default     = "westus"
}
variable "random_integer_max" {
	default = "99999"
}
variable "random_integer_min" {
	default = "10000"
}
variable "remote_debugging_enabled" {
	default = "true"
}
variable "remote_debugging_version" {
	default = "VS2015"
}
variable requested_service_objective_name {
	default = "Basic"
}
variable "size" {
	type = "string"
	default = "1042"
}
variable "sql_admin" {
	description = "The administrator username of the SQL Server."
	default = "adminaccount"
}
variable "sql_password" {
	description = "The administrator password of the SQL Server."
	default = "Admin123@password"
}
variable "start_ip_address" {
	default = "0.0.0.0"
}
variable "type" {
	default = "page"
}

variable "subscription_id" {}
#variable "version" {
#	default = "version"
#}