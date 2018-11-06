output "dbserver_sg_id" {	
	value = ["${element(concat(aws_security_group.sgdb.*.id, list("")),0)}"]
}
output "webserve_sg_id" {	
	value = ["${element(concat(aws_security_group.sgweb.*.id, list("")),0)}"]
}
output "vpc_id" {	
	value = "${element(concat(aws_vpc.vpc.*.id, list("")),0)}"
}
output "vpc_cidr_block" {	
	value = "${element(concat(aws_vpc.vpc.*.cidr_block, list("")),0)}"
}
output "private_subnets_id" {	
	value = ["${element(concat(aws_subnet.private_subnet.*.id, list("")),0)}"]
}
output "public_subnets_id" {
	value = ["${element(concat(aws_subnet.public_subnet.*.id, list("")),0)}"]
}
output "main_route_table" {
	value = "${element(concat(aws_route_table.route_table.*.id, list("")),0)}"
}