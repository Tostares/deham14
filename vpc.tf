# Create a VPC to launch our instances into
resource "aws_vpc" "dev_vpc" {
  cidr_block = "10.0.0.0/16"  
  enable_dns_hostnames = true 
  enable_dns_support = true
  
  tags       =  {
    name     = "deham14-vpc"
  }       
}

resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "deham14-public1"
  }
}

resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "deham14-private1"
  }
}

resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-west-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "deham14-public2"
  }
}

resource "aws_subnet" "private-2" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "deham14-private2"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dev_vpc.id
  tags = {
    Name = "deham14-igw"
  }
}

# Define the security group
resource "aws_security_group" "web_sg" {
  name_prefix = "webserver-sg"
  vpc_id      = aws_vpc.dev_vpc.id

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

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Webserver"
  }
}

# Create a route table
resource "aws_route_table" "RB_Public_RouteTable" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "deham14-publicRT"
  }
}

# Create a route table
resource "aws_route_table" "RB_Private_RouteTable" {
  vpc_id = aws_vpc.dev_vpc.id

  #route { 
  #  cidr_block = "0.0.0.0/0"
  #  gateway_id = aws_internet_gateway.igw.id
  #}
  tags = {
    Name = "deham14-privateRT"
  }
}


resource "aws_route_table_association" "Public_Subnet1_Asso" {
  route_table_id = aws_route_table.RB_Public_RouteTable.id
  subnet_id      = aws_subnet.public-1.id
  depends_on     = [aws_route_table.RB_Public_RouteTable, aws_subnet.public-1]
}


resource "aws_route_table_association" "Private_Subnet1_Asso" {
  route_table_id = aws_route_table.RB_Private_RouteTable.id
  subnet_id      = aws_subnet.private-1.id
  depends_on     = [aws_route_table.RB_Private_RouteTable, aws_subnet.private-1]
}

resource "aws_route_table_association" "Public_Subnet2_Asso" {
  route_table_id = aws_route_table.RB_Public_RouteTable.id
  subnet_id      = aws_subnet.public-2.id
  depends_on     = [aws_route_table.RB_Public_RouteTable, aws_subnet.public-2]
}

resource "aws_route_table_association" "Private_Subnet2_Asso" {
  route_table_id = aws_route_table.RB_Private_RouteTable.id
  subnet_id      = aws_subnet.private-2.id
  depends_on     = [aws_route_table.RB_Private_RouteTable, aws_subnet.private-2]
}

