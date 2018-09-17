resource "aws_instance" "weberver-example" {
  ami           = "ami-6cd6f714"
  instance_type = "t2.micro"
}