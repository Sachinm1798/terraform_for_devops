resource "aws_key_pair" "my_key" {
  key_name   = "terra-key-ec2"
  public_key = file("terra-key-ec2.pub")
}

resource "aws_default_vpc" "default" {


}

resource "aws_security_group" "my_security_group" {
  name        = "automatesg"
  description = "this will add a TF generated Security group"
  vpc_id      = aws_default_vpc.default.id #interpolation

  #Inbound Rules  
  ingress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open"

  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP ingress"

  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Flask APP"
  }
  #outbound rules

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access open outbound"

  }
}

resource "aws_instance" "my_instance" {
  for_each        = tomap({
                          "instance_0" = "t3.micro",
                          "instance_1" = "t3.micro"
                         }) #This completely changes the instance type and name accordingly.
                            #This is also another meta argument 
 #count           = 3 #meta argument-multiple instances at one go
  depends_on      = [ aws_security_group.my_security_group , aws_key_pair.my_key ] #start resources based on dependency
  key_name        = aws_key_pair.my_key.key_name
  security_groups = [aws_security_group.my_security_group.name]
  instance_type   = each.value
  ami             = var.ec2_ami_id #calling variables in file
  user_data       = file("install-nginx.sh")  #Run shell script at startup
  root_block_device {
    volume_size =  var.env == "prd" ? 20 : var.ec2_default_root_storage_size #var.ec2_root_storage_size #evaluation of conditional expression
    volume_type = "gp3"
  }
  tags = {
    Name = each.key
  }

}
