variable "AWS_REGION" {
  type = string
  default = "us-west-2"
}

provider "aws" {
  region = "${var.AWS_REGION}"
}

resource "aws_vpc" "issa-private-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  instance_tenancy = "default"

  tags = {
    Name = "issa-private-vpc"
  }
}

resource "aws_subnet" "issa-private-subnet" {
  vpc_id = "${aws_vpc.issa-private-vpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = false  // makes it a private subnet
  availability_zone = "us-west-2b"
}

resource "aws_internet_gateway" "issa-igw" {
    vpc_id = "${aws_vpc.issa-private-vpc.id}"
    tags = {
        Name = "issa-igw"
    }
}

resource "aws_route_table" "issa-route-table" {
    vpc_id = "${aws_vpc.issa-private-vpc.id}"
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = "${aws_internet_gateway.issa-igw.id}" 
    }
    
    tags = {
        Name = "issa-crt"
    }
}

resource "aws_route_table_association" "issa-crta-private-subnet"{
    subnet_id = "${aws_subnet.issa-private-subnet.id}"
    route_table_id = "${aws_route_table.issa-route-table.id}"
}

resource "aws_key_pair" "sam_test_new_key" {
  key_name   = "sam_test_new_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzIp5hD3rNeWZ0PIpZX0jfrZ/Zhs58fcnQspmhe+vAh7ya6SYPVFSX0uTA9baED6cNFgm+POwR0V9B73duxgcG48sXLOTRqOEm+gOJwxA52cXsSv/LYj6FwWMXJlBzreg7QUlsx61Jqrb8zYXNiERv9buNj91QP8VICJZx1liPQiy3dkOMB6W+fr21rbUtZjZSsb/j/M8K7WtA+WDP5J7M4YFeIfOUejR3D1/79jMOgae0+AtkMe4b2Ln+7+AsPcRfOChkZjCBKEodtL1o45afBAqQDZoknCbY4vtyrBD3KHrOhzvIBAPkgRIAWbfD3SSzEIooFKPP4Xiq7L9o8S2N shaycraft@Samuels-MacBook-Pro.local"
}

resource "aws_instance" "SshKeyTest" {
  ami           = "ami-a58d0dc5"
  instance_type = "t2.micro"
  key_name = "sam_test_new_key"
  tags = {
    Name = "SshKeyTest"
  }
  subnet_id = aws_subnet.issa-private-subnet.id
  vpc_security_group_ids = [aws_security_group.issa-security-group.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    key = file("/Users/shaycraft/.ssh/id_rsa_aws_terraform_tutorial")
    timeout     = "4m"
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "issa-security-group" {
  vpc_id = "${aws_vpc.issa-private-vpc.id}"
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    }
  ]
}
