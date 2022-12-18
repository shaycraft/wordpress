provider "aws" {
  region = "us-west-2"

}

resource "aws_key_pair" "sam_test_new_key" {
  key_name   = "sam_test_new_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzIp5hD3rNeWZ0PIpZX0jfrZ/Zhs58fcnQspmhe+vAh7ya6SYPVFSX0uTA9baED6cNFgm+POwR0V9B73duxgcG48sXLOTRqOEm+gOJwxA52cXsSv/LYj6FwWMXJlBzreg7QUlsx61Jqrb8zYXNiERv9buNj91QP8VICJZx1liPQiy3dkOMB6W+fr21rbUtZjZSsb/j/M8K7WtA+WDP5J7M4YFeIfOUejR3D1/79jMOgae0+AtkMe4b2Ln+7+AsPcRfOChkZjCBKEodtL1o45afBAqQDZoknCbY4vtyrBD3KHrOhzvIBAPkgRIAWbfD3SSzEIooFKPP4Xiq7L9o8S2N shaycraft@Samuels-MacBook-Pro.local"
}

resource "aws_instance" "Wordpresstest" {
  ami           = "ami-0397abf91212932d1"
  instance_type = "t2.micro"
  key_name      = "sam_test_new_key"
  tags = {
    Name = "WordpressTest"
  }
  vpc_security_group_ids = [aws_security_group.main.id]

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "admin"
    private_key = file("/Users/shaycraft/.ssh/id_rsa_aws_terraform_tutorial")
    timeout     = "4m"
  }
}

data "aws_vpc" "default" {
  default = true
}


resource "aws_security_group" "main" {
  # vpc_id = "vpc-3cfca05b"
  vpc_id = data.aws_vpc.default.id
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
      description      = "SSH Port"
      from_port        = 22
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 22
    },
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = "HTTP port"
      from_port        = 80
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 80
    },
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = "HTTPS port"
      from_port        = 443
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = 443
    }
  ]
}
