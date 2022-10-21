resource "aws_vpc" "ecs" {
  cidr_block = "172.31.0.0/16"
  tags = {
    Name = "Taskvpc"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  cidr_block              = "cidrsubnet(aws_vpc.default.cidr_block, 8, 2 + count.index)"
  availability_zone       = "data.aws_availability_zones.available_zones.names[count.index]"
  vpc_id                  = "vpc-0382f51c959645e99"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private" {
  count             = 2
  cidr_block        = "cidrsubnet(aws_vpc.default.cidr_block, 8, count.index)"
  availability_zone = "data.aws_availability_zones.available_zones.names[count.index]"
  vpc_id            = "vpc-0382f51c959645e99"
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = "vpc-0382f51c959645e99"
}

resource "aws_route" "internet_access" {
  route_table_id         = "rtb-07d1bd9f86996008e"
  destination_cidr_block = "172.31.0.0/16"
  gateway_id             = "igw-0d99675bb66becd2c"
}

resource "aws_eip" "gateway" {
  count      = 2
  vpc        = true
  depends_on = [aws_internet_gateway.gateway]
}

resource "aws_nat_gateway" "gateway" {
  count         = 2
  subnet_id     = "subnet-06d9db5a1de59d5c7"
  allocation_id = "igw-0d99675bb66becd2c"
}

resource "aws_route_table" "private" {
  count  = 2
  vpc_id = "vpc-0382f51c959645e99"

  route {
    cidr_block = "172.31.16.0/20"
    nat_gateway_id = "igw-0d99675bb66becd2c"
  }
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = "subnet-0794f192b8185a46a"
  route_table_id = "rtb-07d1bd9f86996008e"
}

resource "aws_security_group" "lb" {
  name        = "ecs-alb-security-group"
  vpc_id      = "vpc-0382f51c959645e99"

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["172.31.0.0/16"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["172.31.0.0/16"]
  }
}
