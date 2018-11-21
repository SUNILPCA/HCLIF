# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Creating Launch Configuration
# 
# An ASG can automatically launch a cluster of EC2 Instances, monitor their health, 
# automatically restart failed nodes, and adjust the size of the cluster in response to demand
# 
# The first step in creating an ASG is to create a launch configuration, which specifies how to configure each EC2 Instance in the ASG
# lifecycle 	: 	You can add a lifecycle block to any Terraform resource to customize its lifecycle behavior. One of the available lifecycle 
#					settings is create_before_destroy, which tells Terraform to always create a replacement resource before destroying an original 
#					(e.g. when replacing an EC2 Instance, always create the new Instance before deleting the old one).
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_launch_configuration" webserver_lc{
	image_id       	= "${var.amis}"
	instance_type 	= "${var.instance_type}"
	security_groups = ["${var.webserver_security_group_id}"]
  
	user_data = "${var.user_data}"
		
	# Important note: whenever using a launch configuration with an auto scaling group, you must set
	# create_before_destroy = true. However, as soon as you set create_before_destroy = true in one resource, you must
	# also set it in every resource that it depends on, or you'll get an error about cyclic dependencies (especially when
	# removing resources).
  
	lifecycle {
		create_before_destroy = true
	}
}

output "webserver_lc_id" {  
  value = "${element(concat(aws_launch_configuration.webserver_lc.*.id, list("")),0)}"
}

output "webserver_lc_name" {  
  value = "${element(concat(aws_launch_configuration.webserver_lc.*.name, list("")),0)}"
}