# Master CloudSQL
resource "google_sql_database_instance" "master" {
	name                	= "${var.application}-sql-master-demo"
	database_version     	= "${var.database_version}"

	settings {
		tier                        = "${var.tier}"
		activation_policy           = "${var.activation_policy}"
		authorized_gae_applications = ["${var.authorized_gae_applications}"]
		disk_autoresize             = "${var.disk_autoresize}"
		ip_configuration            = ["${var.ip_configuration}"]
		location_preference         = ["${var.location_preference}"]
		maintenance_window          = ["${var.maintenance_window}"]
		disk_size                   = "${var.disk_size}"
		disk_type                   = "${var.disk_type}"
		pricing_plan                = "${var.pricing_plan}"
		replication_type            = "${var.replication_type}"
		database_flags              = ["${var.database_flags}"]
		backup_configuration 		= ["${var.backup_configuration}"]
	}
	#ip_configuration {
	#	authorized_networks = [
	#	]
	#}	
	
	replica_configuration = ["${var.replica_configuration}"]
}
# Replica CloudSQL
resource "google_sql_database_instance" "master_replica" {
	name                 = "${var.application}-sql-replica-demo"
	database_version     = "${var.database_version}"
	master_instance_name = "${google_sql_database_instance.master.name}"
	
	replica_configuration {
		failover_target = true
	}
	
	settings {
		tier                        = "${var.tier}"
		activation_policy           = "${var.activation_policy}"
		authorized_gae_applications = ["${var.authorized_gae_applications}"]
		disk_autoresize             = "${var.disk_autoresize}"
		location_preference         = ["${var.location_preference}"]
		disk_size                   = "${var.disk_size}"
		disk_type                   = "${var.disk_type}"
		database_flags              = ["${var.database_flags}"]
		crash_safe_replication      = true
	}
}
resource "google_sql_database" "master" {
	count     				= "${var.master_instance_name == "" ? 1 : 0}"
	name      				= "${var.application}-db"
	instance  				= "${google_sql_database_instance.master.name}"
	charset   				= "${var.db_charset}"
	collation 				= "${var.db_collation}"
}
resource "random_id" "user-password" {
	byte_length = 8
}
resource "google_sql_user" "user" {
	count    				= "${var.master_instance_name == "" ? 1 : 0}"
	name     				= "${var.user_name}"
	instance 				= "${google_sql_database_instance.master.name}"
	host     				= "${var.user_host}"
	password 				= "${var.user_password == "" ? random_id.user-password.hex : var.user_password}"
}
