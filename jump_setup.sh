#!/bin/bash
yum install ansible git wget unzip -y;
git clone ${var.git_url};
ansible-playbook -i "${aws_instance.testvm-rz1.private_ip}", "${aws_instance.testvm-rz3.private_ip}"  ${var.mediawiki_playbook} -e dbaddress=$1 -e dbusername=$2 -e dbpassword=$3