
resource "aws_instance" "testvm-rz1" {

  ami = "ami-0f2b4fc905b0bd1f1"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.myvpc_rz1.id}"
  key_name = "${aws_key_pair.mykey1.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allowssh.id}"]
  tags = {
      name = "testvm-rz1"
  }
  user_data = <<-EOF
    #!/bin/bash
    yum install  git wget unzip epel-release httpd -y
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
    yum --enablerepo=remi-php72 install php php-apcu php-intl php-mbstring php-xml -y 
    setsebool -P httpd_can_network_connect_db 1
    wget https://releases.wikimedia.org/mediawiki/1.33/mediawiki-1.33.0.tar.gz -O /usr/local/
    tar -xvf  /usr/local/mediawiki-1.33.0.tar.gz -C /usr/local/
    mv /usr/local/mediawiki-1.33.0 /usr/local/mediawiki
    cp -r /usr/local/mediawiki/ /var/www/html/
    wget https://local-settings-mediawiki.s3.us-east-2.amazonaws.com/LocalSettings.php -o /var/www/html/mediawiki/
    systemctl start httpd

    git clone ${var.git_url};
    
  EOF
}

output "testvm-rz1_private_ip" {
  value = "${aws_instance.testvm-rz1.private_ip}"

}

output "testvm-rz1_public_ip" {
  value = "${aws_instance.testvm-rz1.public_ip}"

}


resource "aws_instance" "testvm-rz3" {

  ami = "ami-0f2b4fc905b0bd1f1"
  instance_type = "t2.micro"
  subnet_id = "${aws_subnet.myvpc_rz3.id}"
  key_name = "${aws_key_pair.mykey1.key_name}"
  vpc_security_group_ids = ["${aws_security_group.allowssh.id}"]
  tags = {
      name = "testvm-rz3"
  }
  user_data = <<-EOF
    #!/bin/bash
    yum install  git wget unzip epel-release httpd -y
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
    yum --enablerepo=remi-php72 install php php-apcu php-intl php-mbstring php-xml -y
    setsebool -P httpd_can_network_connect_db 1
    wget https://releases.wikimedia.org/mediawiki/1.33/mediawiki-1.33.0.tar.gz -O /usr/local/
    tar -xvf  /usr/local/mediawiki-1.33.0.tar.gz -C /usr/local/
    mv /usr/local/mediawiki-1.33.0 /usr/local/mediawiki
    cp -r /usr/local/mediawiki/ /var/www/html/
    wget https://local-settings-mediawiki.s3.us-east-2.amazonaws.com/LocalSettings.php -o /var/www/html/mediawiki/
    systemctl start httpd
    git clone ${var.git_url};
    
  EOF
}

output "testvm-rz3_private_ip" {
  value = "${aws_instance.testvm-rz3.private_ip}"

}

output "testvm-rz3_public_ip" {
  value = "${aws_instance.testvm-rz3.public_ip}"

}

