# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Creating EC2 instance which will be deploy a cluster of web server that will run a simple "Hello, World" web server
# 
# ami				: 	The Amazon Machine Image to run on the EC2 Instance 
# instance_type		: 	The type of EC2 Instance to run. Each EC2 Instance Type has different 
# 				  		amount CPU, memory, disk space, and networking specs. 
# 				  		The example below uses "t2.micro", which has 1 # virtual CPU, 1GB of memory, and is part of the AWS free tier.
# tags				: 	EC2 instance name
# user_data			: 	script as part of user data (real world replaced with AMI)
# security_group 	: 	By default, AWS does not allow any incoming or outgoing traffic from an EC2 Instance. To allow the EC2 Instance to receive traffic on port 8080, 
# 						we need to create a security group
# cidr_blocks		:	CIDR blocks are a concise way to specify IP address ranges
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
resource "aws_instance" "webserver" {
	ami           = "${var.amis}"
	instance_type = "${var.instance_type}"
	key_name 	  = "${var.key_name}"
	source_dest_check = false
	
	#The syntax is "${TYPE.NAME.ATTRIBUTE}". When one resource references another resource, 
	#we create an implicit dependency (injecting the security group)
	vpc_security_group_ids = ["${aws_security_group.instance.id}"]	
	
	user_data = "${var.user_data}" 
	tags {
		Name = "${var.application}"
	}
}

# Creating Security Group for EC2
resource "aws_security_group" "instance" {
	name 		= "${var.application}_sg"
	description = "Allow incoming HTTP connections & SSH access"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks =  ["0.0.0.0/0"]
	}	
	
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks =  ["0.0.0.0/0"]
	}

	tags {
		Name = "${var.application} Server SG"
	}
}

output "public_ip" {
	value = "${element(concat(aws_instance.webserver.*.public_ip, list("")),0)}"	
}

output "webserver_security_group_id" {
	value = ["${element(concat(aws_security_group.instance.*.id, list("")),0)}"]
}