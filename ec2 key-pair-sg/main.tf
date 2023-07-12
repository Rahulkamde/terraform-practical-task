resource "aws_instance" "cloud-aws" {
  ami           = "ami-0f8e81a3da6e2510a"
  instance_type = "t3.micro"
  key_name      = "cali-key"
  vpc_security_group_ids = [aws_security_group.cloud-awssg.id]

tags = {
  name = "cloudknowledge"
 }
}

resource "aws_key_pair" "cloud-aws" {
  key_name   = "cali-key"
  public_key = "ssh-paste.pub-key"
}

resource "aws_eip" "cloud-awseip" {
  instance = aws_instance.cloud-aws.id
}

resource "aws_default_vpc" "cloud-aws" {
  tags = {
    Name = "Default VPC"
  }
}

resource "aws_security_group" "cloud-awssg" {
  name        = "cloud-awssg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_default_vpc.cloud-aws.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "cloud-aws"
  }
}
