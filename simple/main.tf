# Specify the provider and access details
provider "aws" {
}

resource "aws_vpc" "main-vpc" {
  cidr_block = "10.254.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"

  tags {
    Name="main-vpc"
  } 
}

resource "aws_internet_gateway" "default" {
  vpc_id  = "${aws_vpc.main-vpc.id}"
}

resource "aws_route" "default" {
  route_table_id  = "${aws_vpc.main-vpc.main_route_table_id}"
  destination_cidr_block  = "0.0.0.0/0"  
  gateway_id  = "${aws_internet_gateway.default.id}"
}


resource "aws_subnet" "default-small"{
  vpc_id  = "${aws_vpc.main-vpc.id}"
  cidr_block = "10.254.0.0/24"
  map_public_ip_on_launch = true

  tags{
    Name="default-small"
  }
}


resource "aws_default_security_group" "default" {
  vpc_id = "${aws_vpc.main-vpc.id}"

  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags{
    Name="Default SG - Managed by Terraform"
  }

}
