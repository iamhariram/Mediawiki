
data "aws_security_group" "allowssh" {

 tags = {
     name = "allowssh"
    }
}

data "aws_vpc" "myvpc" {
  tags = {
      name = "myvpc"
  }
}


data "aws_subnet" "myvpc_rz1" {

    tags = {
        name = "myvpc_rz1"
    }
}

data "aws_subnet" "myvpc_rz2" {

    tags = {
        name = "myvpc_rz2"
    }
}


data "aws_subnet" "myvpc_rz3" {

    tags = {
        name = "myvpc_rz3"
    }
}

resource "aws_key_pair" "ec2keypairs" {
    key_name = "ec2keypair"
    public_key ="${var.instance_pk}"
  
}


resource "aws_route_table" "private_route_rz1" {
    vpc_id = "${data.aws_vpc.myvpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.testvm-rz1.id}"
    }  
}

resource "aws_route_table_association" "private_subnet_1" {
    subnet_id = "${data.aws_subnet.myvpc_rz1.id}"
    route_table_id = "${aws_route_table.private_route_rz1.id}"
}


resource "aws_route_table" "private_route_rz3" {
    vpc_id = "${data.aws_vpc.myvpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.testvm-rz3.id}"
        
    }  
}

resource "aws_route_table_association" "private_subnet_3" {
    subnet_id = "${data.aws_subnet.myvpc_rz3.id}"
    route_table_id = "${aws_route_table.private_route_rz3.id}"
}

resource "aws_instance" "testvm-rz1" {

  ami = "ami-0520e698dd500b1d1"
  instance_type = "t2.micro"
  subnet_id = "${data.aws_subnet.myvpc_rz1.id}"
  key_name = "${aws_key_pair.ec2keypairs.key_name}"
  vpc_security_group_ids = ["${data.aws_security_group.allowssh.id}"]
}

output "testvm-rz1_private_ip" {
  value = "${aws_instance.testvm-rz1.private_ip}"

}



resource "aws_instance" "testvm-rz3" {

  ami = "ami-0520e698dd500b1d1"
  instance_type = "t2.micro"
  subnet_id = "${data.aws_subnet.myvpc_rz3.id}"
  key_name = "${aws_key_pair.ec2keypairs.key_name}"
  vpc_security_group_ids = ["${data.aws_security_group.allowssh.id}"]

}

output "testvm-rz2_private_ip" {
  value = "${aws_instance.testvm-rz1.private_ip}"

}