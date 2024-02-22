resource "aws_instance" "demo-server" {
  ami           = "ami-0f960def03d1071d3"
  instance_type = "t2.micro"
  key_name      = "emaad-keypair"
}


resource "aws_security_group" "demo-sg" {
  name        = "demo-sg"
  description = "SSH Access to instance"

  ingress {
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    name = "ssh-port"
  }

}