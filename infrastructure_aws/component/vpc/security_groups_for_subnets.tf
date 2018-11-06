# Define the security group for public subnet
resource "aws_security_group" "sgweb" {
	count= "${var.count}"
	name = "${var.environment}_sg_web"
	description = "Allow incoming HTTP connections & SSH access"

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = -1
		to_port = -1
		protocol = "icmp"
		cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks =  ["0.0.0.0/0"]
	}

	vpc_id="${aws_vpc.vpc.id}"

	tags {
		Name = "${var.environment}_Web Server SG"
	}
}

# Define the security group for private subnet
resource "aws_security_group" "sgdb"{
  count= "${var.count}"	
  name = "${var.environment}_sg_db"
  description = "Allow traffic from public subnet"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnets_cidr_block}"]
  }

  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = ["${var.public_subnets_cidr_block}"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["${var.public_subnets_cidr_block}"]
  }

  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "${var.environment}_DB SG"
  }
}