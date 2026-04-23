resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name      = "Nginx-resources"
    ManagedBy = "Terraform"
    Project   = "resources-project"
  }
}

resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name      = "Public Subnet"
    ManagedBy = "Terraform"
    Project   = "resources-project"
  }
}
