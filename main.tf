# Create a VPC
resource "aws_vpc" "zcsg" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "zcsg-vpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "zcsg" {
  vpc_id = aws_vpc.zcsg.id

  tags = {
    Name = "zcsg-igw"
  }
}

# Create a public subnet
resource "aws_subnet" "zcsg" {
  vpc_id                  = aws_vpc.zcsg.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-southeast-1a"
  map_public_ip_on_launch = true  # <- assign public IP automatically

  tags = {
    Name = "zcsg-public-subnet"
  }
}

# Create a route table for public subnet
resource "aws_route_table" "zcsg" {
  vpc_id = aws_vpc.zcsg.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.zcsg.id
  }

  tags = {
    Name = "zcsg-public-rt"
  }
}

# Associate route table with public subnet
resource "aws_route_table_association" "zcsg" {
  subnet_id      = aws_subnet.zcsg.id
  route_table_id = aws_route_table.zcsg.id
}

# Security group allowing SSH
resource "aws_security_group" "zcsg" {
  name        = "zcsg-sg"
  description = "Allow SSH"
  vpc_id      = aws_vpc.zcsg.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "zcsg-sg"
  }
}

# Launch EC2 instance in public subnet
resource "aws_instance" "zcsg" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.zcsg.id
  vpc_security_group_ids = [aws_security_group.zcsg.id]
  associate_public_ip_address = true  # <- assign public IP

  tags = {
    Name = "terraform-ec2-zcsg"
  }
}

# Create a 1 GB EBS volume in the same AZ as EC2
resource "aws_ebs_volume" "zcsg" {
  availability_zone = aws_instance.zcsg.availability_zone
  size              = var.ebs_size

  tags = {
    Name = "terraform-ebs-zcsg"
  }
}

# Attach the EBS volume to the EC2 instance
resource "aws_volume_attachment" "zcsg" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.zcsg.id
  instance_id = aws_instance.zcsg.id
}