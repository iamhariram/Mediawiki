resource "aws_db_subnet_group" "mysubnetgroup" {
  name       = "mysubnetgroup"
  subnet_ids = [
    "${aws_subnet.myvpc_rz1.id}", 
    "${aws_subnet.myvpc_rz3.id}"
    ]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "mediadb" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.t2.micro"
  name = "mydb"
  username = "${var.dbuname}"
  password = "${var.dbpasswd}"
  multi_az = "true"
  publicly_accessible = "true"
  db_subnet_group_name = "${aws_db_subnet_group.mysubnetgroup.id}"
}