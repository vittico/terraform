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



