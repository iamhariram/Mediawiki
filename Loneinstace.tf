provider "aws" {
 
  version = "~> 2.0"
  region = "ap-south-1"
  access_key = "AKIAJSTIA6PJV4JMSO4A"
  secret_key = "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"
}


data aws_vpc "vpc_name"{}
data aws_security_group "sg_name"{}
data aws_subnet_ids "sb_name"{
  vpc_id = data.aws_vpc.vpc_name.id
}

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
  #public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAtnLjdFmYc0VGYQreNctyyA6ODaK9oMP0MUOqGGS6urliDoN4pkW+jAedDOAc8S4g2LyqZAGCGpfSJ3sNHpYZ+XCV5mNQnQ4diIa7M4WvldwdMQXc9IMnUooJEejjH/F9cEAWIBo/Wby3YkdzULyLdI54pBb/I8vhNl0zgrbR71jbPtMQQH0kXczxzzedrk6wwTNden8hdlcEDRykLLvDpnDDnlfxMRtCBBeLfJEI9pYOq0IBkfYG6XZlawRumdi4SHe5oWlrsPOV/C+f86faEWY9U/cA10+lCbfTdzFNCnfSSv2gMX1zXEhzF98UheMXtYRY0eKrxYr4vb/hvVk2xw=="
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAtnLjdFmYc0VGYQreNctyyA6ODaK9oMP0MUOqGGS6urliDoN4pkW+jAedDOAc8S4g2LyqZAGCGpfSJ3sNHpYZ+XCV5mNQnQ4diIa7M4WvldwdMQXc9IMnUooJEejjH/F9cEAWIBo/Wby3YkdzULyLdI54pBb/I8vhNl0zgrbR71jbPtMQQH0kXczxzzedrk6wwTNden8hdlcEDRykLLvDpnDDnlfxMRtCBBeLfJEI9pYOq0IBkfYG6XZlawRumdi4SHe5oWlrsPOV/C+f86faEWY9U/cA10+lCbfTdzFNCnfSSv2gMX1zXEhzF98UheMXtYRY0eKrxYr4vb/hvVk2xw=="
} 

resource "aws_elb" "myeld" {
  name = "apache-elb"
  listener {
    instance_port = 80
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
  instances = [aws_instance.test1[0].id , aws_instance.test1[1].id]
  subnets = data.aws_subnet_ids.sb_name.ids

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
     "apt-get update"
     "apt-get install apache2 -y"
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

output "aws_instances" {
  value = "${aws_instance.test1[0].id}"
}

output "sb_name" {
  value = "${data.aws_subnet_ids.sb_name.ids}"
}

output "ld_data" {
  value = "${aws_elb.myeld.dns_name}"
}
