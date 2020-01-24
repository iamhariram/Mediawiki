provider "aws" {
 
  version = "~> 2.0"
  region = "ap-south-1"
}


data aws_vpc "vpc_name"{}
data aws_security_group "sg_name"{}

data aws_ami "var_ami"{
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-20191002"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "sshkey" {

  key_name = "sshkey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCSAJVhbpdMiJM1TgQLVms+as9nQFkYH0ioHEEo+/k4Bx/pqgOsWOGuevF8HzHQXU5qg9c2/9EMHU85O1C2QvTKHw6CVOJl3SWOIfljTF0Wdefx5B399EYbTAecz7sGW7BPXdtStA5S4miVBX2ftgdXcLQHgm4zBFuipaE5YheqS/gWDF5NiJuePs3+LwgCGbhFyPzxI5zVcdDZvp6capMJueqsQ7LwuwRxHt9UO+6weLMkiZMzSXQ70qMdB0205U7K34RInw0obsLIUiHDwYrKOAndfNxJaKtOn6fxAObVnFJc9vW6LHGQDK1Pwcx5GSdGWgHFUZ8MMlh1GcH67SKL"
}


resource "aws_instance" "test1" {
   count = 2
   ami = data.aws_ami.var_ami.id
   vpc_security_group_ids = [data.aws_security_group.sg_name.id]
   instance_type = "t2.micro"
   key_name = aws_key_pair.sshkey.key_name
   tags = {
     name = "server"
   }
   user_data = <<EOF
     "apt-get install apache2"
     EOF
  
}

output "var_ami" {
  value = "${data.aws_ami.var_ami.id}"
}

output "vpc_name" {
  value = "${data.aws_vpc.vpc_name.id}"
}

output "sg_name" {
  value = "${data.aws_security_group.sg_name.id}"
}

output "aws_public_ip_1" {
  value = "${aws_instance.test1[0].public_ip}"
  
}
