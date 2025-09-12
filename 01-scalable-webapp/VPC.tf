# -------------------------
# VPC
# -------------------------
resource "aws_vpc" "WebApp" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "WebApp"
  }
}

# -------------------------
# Subnets
# -------------------------
resource "aws_subnet" "PublicSubnet-1" {
  vpc_id                  = aws_vpc.WebApp.id
  cidr_block              =  var.public_subnet_cidr_1
  map_public_ip_on_launch = true
  availability_zone = var.AZ-A

  tags = {
    Name = "PublicSubnet-1"
  }
}

resource "aws_subnet" "PublicSubnet-2" {
  vpc_id                  = aws_vpc.WebApp.id
  cidr_block              = var.public_subnet_cidr_2
  map_public_ip_on_launch = true
  availability_zone = var.AZ-B

  tags = {
    Name = "PublicSubnet-2"
  }
}

resource "aws_subnet" "PrivateSubnet-1" {
  vpc_id                  = aws_vpc.WebApp.id
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = false
  availability_zone = var.AZ-A

  tags = {
    Name = "PrivateSubnet-1"
  }
}



# -------------------------
# Internet Gateway
# -------------------------
resource "aws_internet_gateway" "WebApp-IGW" {
  vpc_id = aws_vpc.WebApp.id

  tags = {
    Name = "WebApp-IGW"
  }
}


# -------------------------
# Elastic IP for NAT
# -------------------------
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}


# -------------------------
# NAT Gateway (Public Subnet)
# -------------------------
resource "aws_nat_gateway" "WebApp-NATGW" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.PublicSubnet-1.id

  tags = {
    Name = "NAT-Gateway"
  }
}

# -------------------------
# Route Tables
# -------------------------

# Public Route Table
resource "aws_route_table" "PublicRTB" {
  vpc_id = aws_vpc.WebApp.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.WebApp-IGW.id
  }

  tags = {
    Name = "PublicRTB"
  }
}

resource "aws_route_table_association" "public_assoc-1" {
  subnet_id      = aws_subnet.PublicSubnet-1.id
  route_table_id = aws_route_table.PublicRTB.id
}

# resource "aws_route_table_association" "public_assoc-2" {
#   subnet_id      = aws_subnet.PublicSubnet-2.id
#   route_table_id = aws_route_table.PublicRTB.id
# }



# Private Route Table
resource "aws_route_table" "PrivateRTB" {
  vpc_id = aws_vpc.WebApp.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.WebApp-NATGW.id
  }

  tags = {
    Name = "PrivateRTB"
  }
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.PrivateSubnet-1.id
  route_table_id = aws_route_table.PrivateRTB.id
}