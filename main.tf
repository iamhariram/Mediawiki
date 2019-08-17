provider "aws" {
    region = "us-east-2"
    access_key = "${var.phariram_ak}"
    secret_key = "${var.phariram_sk}"
}

resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.1.0/24"
    instance_tenancy = "default"  
    enable_dns_hostnames="true"
    enable_dns_support="true"
    tags = {
        name = "myvpc"
    }
}

resource "aws_internet_gateway" "igateway" {
    vpc_id = "${aws_vpc.myvpc.id}"
    tags = {
            name = "igateway"
    }

}

resource "aws_route_table" "public_route" {
    vpc_id = "${aws_vpc.myvpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.igateway.id}"
    }  
    tags = {
        name = "public_route"
    }
}

resource "aws_route_table_association" "public_subnet_association" {
    subnet_id = "${aws_subnet.myvpc_rz2.id}"
    route_table_id = "${aws_route_table.public_route.id}"
    
}



resource "aws_security_group" "allowssh" {
    name = "allowssh"
    vpc_id = "${aws_vpc.myvpc.id}"
    ingress {
         from_port = "0"
         to_port = "0"
         protocol = "-1"
         cidr_blocks = ["0.0.0.0/0"] 
    }
    egress {
        from_port = "0"
        to_port = "0"
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        name = "allowssh"
    }
}


resource "aws_subnet" "myvpc_rz1" {
    vpc_id = "${aws_vpc.myvpc.id}"
    cidr_block = "10.0.1.0/26"
    availability_zone = "us-east-2a"
    map_public_ip_on_launch = "true"
    tags = {
        name = "myvpc_rz1"
    }
}
 
 resource "aws_subnet" "myvpc_rz2" {
     vpc_id = "${aws_vpc.myvpc.id}"
     cidr_block = "10.0.1.64/26"
     availability_zone = "us-east-2b"
     map_public_ip_on_launch = "true"
     tags = {
         name = "myvpc_rz2"
     }
 }

 resource "aws_subnet" "myvpc_rz3" {
     vpc_id ="${aws_vpc.myvpc.id}"
     cidr_block = "10.0.1.128/26"
     availability_zone = "us-east-2c"
     map_public_ip_on_launch="true"
     tags = {
         name = "myvpc_rz3"
     }
 }


resource "aws_key_pair" "mykey" {
    key_name = "phariram"
    public_key = "${var.phariram_pk}"
    
}
resource "aws_instance" "jump_server" {

  ami = "ami-0f2b4fc905b0bd1f1"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.myvpc_rz2.id}"
  key_name = "${aws_key_pair.mykey.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allowssh.id}"]
  tags = {
      name = "jump_server"
  }
}

output "key_name" {
  value = "${aws_key_pair.mykey.key_name}"

}
output "jump_server" {
  value = "${aws_instance.jump_server.public_ip}"

}
output "myvpc_id" {
  value = "${aws_vpc.myvpc.id}"
}

output "allowssh_id" {
  value = "${aws_security_group.allowssh.id}"
}

output "myvpc_rz1_id" {
  value = "${aws_subnet.myvpc_rz1.id}"
}

output "myvpc_rz2_id" {
  value = "${aws_subnet.myvpc_rz2.id}"
}

output "myvpc_rz3_id" {
  value = "${aws_subnet.myvpc_rz3.id}"
}
