resource "aws_instance" "web" {
  ami                         = "ami-07dd30dfbe0deecc2"
  associate_public_ip_address = true
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.public_http_traffic.id]
  tags                        = merge(local.common_tags, { Name = "Ec2 Instance" })

  lifecycle {
  	create_before_destroy = true
  }
}


resource "aws_security_group" "public_http_traffic" {
  name        = "public-http-traffic"
  description = "Security group allowing HTTP traffic on port 443 and 80"
  vpc_id      = aws_vpc.main.id
  tags        = merge(local.common_tags, { Name = "Public HTTP Traffic" })
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.public_http_traffic.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}
