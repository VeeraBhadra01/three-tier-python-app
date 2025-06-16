# vpc
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = var.vpc_name
    }
  
}

# create 2 private subnets
resource "aws_subnet" "private_1" {
    cidr_block = var.private_cidrs[0]
    availability_zone = var.aws_azs[0]

    vpc_id = aws_vpc.main.id
  
}

resource "aws_subnet" "private_2" {
    cidr_block = var.private_cidrs[1]
    availability_zone = var.aws_azs[1]

    vpc_id = aws_vpc.main.id
  
}

# 2 public subnets

resource "aws_subnet" "public_1" {
    cidr_block = var.public_cidrs[0]
    availability_zone = var.aws_azs[0]
    vpc_id = aws_vpc.main.id
    map_public_ip_on_launch = true
  
}

resource "aws_subnet" "public_2" {
    cidr_block = var.public_cidrs[1]
    availability_zone = var.aws_azs[1]
    vpc_id = aws_vpc.main.id
    map_public_ip_on_launch = true
  
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

}

# route table for public subnet
resource "aws_route_table" "public_1_route" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "public_2_route" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main.id
    }
  
}

resource "aws_route_table" "private_1_route" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "private_2_route" {
    vpc_id = aws_vpc.main.id
  
}

resource "aws_route_table_association" "public_1_route_association" {
    subnet_id = aws_subnet.public_1.id
    route_table_id = aws_route_table.public_1_route.id
  
}

resource "aws_route_table_association" "public_2_route_association" {
    subnet_id = aws_subnet.public_2.id
    route_table_id = aws_route_table.public_2_route.id
  
}

resource "aws_route_table_association" "private_1_route_association" {
    subnet_id = aws_subnet.private_1.id
    route_table_id = aws_route_table.private_1_route.id
   
}

resource "aws_route_table_association" "private_2_route_association" {
    subnet_id = aws_subnet.private_2.id
    route_table_id = aws_route_table.private_2_route.id
}

