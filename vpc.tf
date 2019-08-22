
resource "aws_vpc" "myvpc" {
    cidr_block = "10.0.1.0/24"
    instance_tenancy = "default"  
    enable_dns_hostnames="true"
    enable_dns_support="true"
    tags = {
        name = "myvpc"
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

resource "aws_route_table" "private_route_rz1" {
    vpc_id = "${aws_vpc.myvpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.testvm-rz1.id}"
    }  
}

resource "aws_route_table_association" "public_subnet_1" {
    subnet_id = "${aws_subnet.myvpc_rz1.id}"
      route_table_id = "${aws_route_table.public_route.id}"
}


resource "aws_route_table" "private_route_rz3" {
    vpc_id = "${aws_vpc.myvpc.id}"
    route {
        cidr_block = "0.0.0.0/0"
        instance_id = "${aws_instance.testvm-rz3.id}"
        
    }  
}

resource "aws_route_table_association" "public_subnet_3" {
    subnet_id = "${aws_subnet.myvpc_rz3.id}"
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
