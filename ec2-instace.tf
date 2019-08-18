
resource "aws_instance" "testvm-rz1" {

  ami = "ami-0520e698dd500b1d1"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.myvpc_rz1.id}"
  key_name = "${aws_key_pair.mykey1.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allowssh.id}"]
  tags = {
      name = "testvm-rz1"
  }
}

output "testvm-rz1_private_ip" {
  value = "${aws_instance.testvm-rz1.private_ip}"

}

output "testvm-rz1_public_ip" {
  value = "${aws_instance.testvm-rz1.public_ip}"

}


resource "aws_instance" "testvm-rz3" {

  ami = "ami-0520e698dd500b1d1"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.myvpc_rz3.id}"
  key_name = "${aws_key_pair.mykey1.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allowssh.id}"]
  tags = {
      name = "testvm-rz3"
  }
}

output "testvm-rz3_private_ip" {
  value = "${aws_instance.testvm-rz3.private_ip}"

}

output "testvm-rz3_public_ip" {
  value = "${aws_instance.testvm-rz3.public_ip}"

}

resource "aws_instance" "jump_server" {

  ami = "ami-0f2b4fc905b0bd1f1"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.myvpc_rz2.id}"
  key_name = "${aws_key_pair.mykey1.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allowssh.id}"]
  tags = {
      name = "jump_server"
    } 
   provisioner "file"{
       source = "./private_key"
       destination = "/root/.ssh/id_rsa"
   }
   provisioner "connection" {
       type = "ssh"
       user = "centos"
       private_key = "${var.private_key_phariram}"
   }
    user_data = << EOF
    yum install ansible git wget unzip -y;
    git clone ${var.git_url};
    ansible-playbook -i ${aws_instance.testvm-rz1.private_ip},${aws_instance.testvm-rz3.private_ip}, ${var.mediawiki_playbook}
  EOF
  }

output "jump_private_ip" {
  value = "${aws_instance.jump_server.private_ip}"

}
output "jump_public_ip" {
  value = "${aws_instance.jump_server.public_ip}"

}