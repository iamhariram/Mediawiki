data "aws_elb" "myvip" {
  name = "myvip"
}
resource "aws_elb_attachment" "myLTM1" {
  elb = "${data.aws_elb.myvip.id}"
  instance = "${aws_instance.testvm-rz1.id}"
  
}
resource "aws_elb_attachment" "myLTM2" {
  elb = "${data.aws_elb.myvip.id}"
  instance = "${aws_instance.testvm-rz3.id}"
  
}