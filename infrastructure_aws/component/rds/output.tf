output "rds_port" {	
	value = "${local.port}"
}

#output "rds_address" {
	#value = "${element(concat(aws_db_instance.rds.*.address, list("")),0)}"
#}

#output "rds_id" {	
	#value = "${element(concat(aws_db_instance.rds.*.id, list("")),0)}"
#}

#output "rds_arn" {	
	#value = "${element(concat(aws_db_instance.rds.*.arn, list("")),0)}"
#}

output "rds_sg_id" {	
	value = "${element(concat(aws_security_group.sg_rds.*.id, list("")),0)}"
}