resource "aws_security_group" "sg_this" {
  name        = "sg_cluste_k8s"
  description = "sg-${var.project_name}"
  vpc_id      = aws_vpc.Main.id

  ingress {
    description      = "Access port 22"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["191.183.196.95/32"]
  }
  ingress {
    description      = "All access Internal"
    from_port        = 0
    to_port          = 65535
    protocol         = "tcp"
    cidr_blocks      = ["172.16.0.0/16"]
  
  }
   
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "sg-${var.project_name}"
  }
}