provider "aws" {
    region = "us-west-2"
  
}

resource "aws_key_pair" "foobar_key" {
    key_name = "sam_test_new_key"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDK0yEgSJyau/533a1nlAusY1YbFzk5MKW8/lFAaO596tepCz51/k1N1J3mHMCi+6hQGhYoTtgsg8/ZG9LhXh7541NI5R9wwzbNcmk5AAIgMlU9hhUynjLYmr3HDidXinAw8akZ8z4QTiXaie+ui8eovUcFDbldEA5Z3iO6M0b4XxP1wJAfCAYpbUmsRfNZV+w5yZuwuze+wQbkAJh6eo64/hl+BHJiLOA0hyYvs8dW3O/8dks9wMw+9Y+L51SS0hswdvk8me9knlNDQ9RC/COfF9VSOcGPCk2qcvE5fMPmVeGLe8S+z/imqV57u4JhXsN8eMWtwEwz/awmNKoU7erNKLwR6s62EurKaR4vg/eQoqaCZr+B9VRZ7lk/lIlrh7T/tPqAXciZw+Tc2xSKW8SmyEIiwbbPlHiDz0ENtYC8gGQOO9nbKhSHj07pM1fiZxY6EP0S45KWLQt8xnUdBw/aQX6KED+WunUu4DJP1Xhzfqghc122EJNZtMv5PrDnWfM= shaycraft@MacBook-Pro.local"
}

resource "aws_instance" "SshKeyTest" {
  ami = "ami-a58d0dc5"
  instance_type = "t2.micro"
  tags = {
    Name = "SshKeyTest"
  }

  connection {
    type = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("/Users/shaycraft/.ssh/id_rsa")
    timeout     = "4m"
  }
}