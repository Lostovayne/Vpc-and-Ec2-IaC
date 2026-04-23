resource "aws_vpc" "this" {
	cidr_block = "10.0.0.0/16"

	tags = {
		Name = "Nginx-resources"
		ManagedBy = "Terraform"
		Project = "resources-project"
	}
}
