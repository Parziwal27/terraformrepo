# modules/vpc/main.tf

# Create VPC
resource "aws_vpc" "this" {
  cidr_block = var.cidr
  tags       = merge({ Name = var.name }, var.tags)
}

# Create Public Subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = merge({ Name = "${var.name}-public-${count.index}" }, var.tags)
}

# Create Private Subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge({ Name = "${var.name}-private-${count.index}" }, var.tags)
}

# Internet Gateway for public subnets
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge({ Name = "${var.name}-igw" }, var.tags)
}

# Route Table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge({ Name = "${var.name}-public-rt" }, var.tags)
}

# Route to Internet Gateway in public route table
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

