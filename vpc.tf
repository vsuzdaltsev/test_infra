resource "aws_vpc" "PROJECT_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true

  tags = merge(map("Name", "Ischenko vpc"), var.default_tags)
}

resource "aws_subnet" "public-subnet" {
  vpc_id            = aws_vpc.PROJECT_vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(map("Name", "Public Subnet"), var.default_tags)
}

resource "aws_subnet" "private-subnet" {
  vpc_id            = aws_vpc.PROJECT_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = merge(map("Name", "Private Subnet"), var.default_tags)
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.PROJECT_vpc.id

  tags = merge(map("Name", "VPC IGW"), var.default_tags)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.PROJECT_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = merge(map("Name", "Public Subnet route table"), var.default_tags)
}

resource "aws_route_table_association" "public-rt" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "server" {
  name        = "vpc_test"
  description = "Allow incoming HTTP connections & SSH access"

  # Can go to s3 through 443 hole
  egress {
    from_port   = 0
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.PROJECT_vpc.id
  tags   = merge(map("Name", "Server SG"), var.default_tags)
}
