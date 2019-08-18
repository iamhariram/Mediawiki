
resource "aws_key_pair" "mykey1" {
    key_name = "mykey1"
    public_key = "${var.phariram_pk}"
}

resource "aws_key_pair" "mykey2" {
    key_name = "mykey2"
    public_key = "${var.instance_pk}"
}