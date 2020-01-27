provider "aws" {
 
  version = "~> 2.0"
  region = "ap-south-1"
  
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
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  instances = [aws_instance.test1.id , aws_instance.test2.id]
  subnets = data.aws_subnet_ids.sb_name.ids
}


resource "aws_instance" "test1" {
   ami = data.aws_ami.var_ami.id
   vpc_security_group_ids = [data.aws_security_group.sg_name.id]
   instance_type = "t2.micro"
   key_name = aws_key_pair.sshkey.key_name
   tags = {
     Name = "Jenkins-server"
   }
   user_data = <<-EOF
     #!/bin/bash
     apt-get update
     apt-get install docker.io -y
     apt-get install ansible -y
     apt install openjdk-8-jdk -y
     wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
     echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list
     apt-get update
     apt-get install jenkins -y
     EOF
  
}

resource "aws_instance" "test2" {
   ami = data.aws_ami.var_ami.id
   vpc_security_group_ids = [data.aws_security_group.sg_name.id]
   instance_type = "t2.micro"
   key_name = aws_key_pair.sshkey.key_name
   tags = {
     Name = "docker-server"
   }
   user_data = <<-EOF
     #!/bin/bash
     apt-get update
     apt-get install docker.io -y
     apt-get install ansible -y
     apt-get install java-8-openjdk-amd64 -y
     apt-get install jenkins
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

output "aws_instances_test1" {
  value = "${aws_instance.test1.public_ip}"
}

output "aws_instances_test2" {
  value = "${aws_instance.test2.public_ip}"
}

output "sb_name" {
  value = "${data.aws_subnet_ids.sb_name.ids}"
}

output "ld_data" {
  value = "${aws_elb.myeld.dns_name}"
}
