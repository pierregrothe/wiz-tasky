# wiz-tasky/modules/vpc/main.tf
# Define the VPC resource
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr  # The CIDR block for the VPC
  # Merge tags from the local.all_tags variable with a Name tag
  tags = merge(
    local.all_tags,
    {
      Name = "${var.project_name}--${var.environment_name}-vpc" # Assigns a name to the VPC with environment name
    }
  )
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnets_cidr)
  vpc_id           = aws_vpc.main.id
  cidr_block       = var.public_subnets_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    local.all_tags,
    { Name = "${var.project_name}--${var.environment_name}-public-${count.index}" }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidr)
  vpc_id           = aws_vpc.main.id
  cidr_block       = var.private_subnets_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    local.all_tags,
    { Name = "${var.project_name}--${var.environment_name}-private-${count.index}" }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.all_tags,
    { Name = "${var.project_name}--${var.environment_name}-igw" }
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    local.all_tags,
    { Name = "${var.project_name}--${var.environment_name}-nat" }
  )
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    local.all_tags,
    { Name = "${var.project_name}--${var.environment_name}-eip" }
  )
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    local.all_tags,
    { Name = "${var.project_name}--${var.environment_name}-public-rt" }
  )
}

# Associate Public Route Table with Public Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    local.all_tags,
    { Name = "${var.project_name}--${var.environment_name}-private-rt" }
  )
}

# Associate Private Route Table with Private Subnets
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

