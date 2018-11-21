# Create a VPC to launch our instances into
resource "aws_vpc" "vpc" {
	cidr_block 						 = "${var.cidr_block}"
	instance_tenancy                 = "${var.instance_tenancy}"
	enable_dns_hostnames             = "${var.enable_dns_hostnames}"
	enable_dns_support               = "${var.enable_dns_support}"
	assign_generated_ipv6_cidr_block = "${var.assign_generated_ipv6_cidr_block}"

	tags {
		Name = "${var.environment} VPC"
		Environment = "${var.environment}"		
	}
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "gw" {
	vpc_id = "${element(concat(aws_vpc.vpc.*.id, list("")),0)}"

	tags {
		Name = "${var.environment} VPC internet gateway"
		Environment = "${var.environment}"
	}
}

# Create public subnets
resource "aws_subnet" "public_subnet" {
	count = "${var.amount_subnets}"
	vpc_id = "${element(concat(aws_vpc.vpc.*.id, list("")),0)}"
	cidr_block = "${element(var.public_subnets_cidr_block, count.index)}"
	availability_zone = "${var.aws_region}${lookup(var.subnets, count.index)}"

	tags {
		Name = "${var.environment}-${var.aws_region}${lookup(var.subnets, count.index)}"
		Environment = "${var.environment}"		
	}
}

# Create private subnets
resource "aws_subnet" "private_subnet" {
	count = "${var.amount_subnets}"
	vpc_id = "${element(concat(aws_vpc.vpc.*.id, list("")),0)}"
	cidr_block = "${element(var.private_subnets_cidr_block, count.index)}"
	availability_zone = "${var.aws_region}${lookup(var.subnets, count.index)}"

	tags {
		Name = "${var.environment}-${var.aws_region}${lookup(var.subnets, count.index)}"
		Environment = "${var.environment}"		
	}
}

# Grant the VPC internet access on its main route table
resource "aws_route_table" "route_table" {
	vpc_id = "${element(concat(aws_vpc.vpc.*.id, list("")),0)}"
	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.gw.id}"
	}

	tags {
		Name = "${var.environment} Public Subnet Route Table"
		Environment = "${var.environment}"
	}
}

# Assign the route table to the public Subnet
resource "aws_route_table_association" "table_association" {
	count = "${var.amount_subnets}"
	subnet_id = "${element(aws_subnet.public_subnet.*.id, count.index)}"
	route_table_id = "${element(concat(aws_route_table.route_table.*.id, list("")),0)}"
}