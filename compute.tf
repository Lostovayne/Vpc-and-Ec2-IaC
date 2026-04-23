resource "aws_instance" "web" {
  ami                         = "ami-0ec10929233384c7f"
  associate_public_ip_address = true
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public.id
  # security_group_ids = [aws_security_group.public.id]
}
