// File: modules/vpc/main.tf
// ---------------------------------------------------------------------------
// VPC Module for wiz-tasky Project
// This module creates a Virtual Private Cloud (VPC) with public and private
// subnets, an Internet Gateway, a NAT Gateway (with an Elastic IP), and the 
// necessary route tables and associations. All resources leverage a centralized
// tag merging strategy using `local.merged_tags`.
// ---------------------------------------------------------------------------

/*
  Resource: aws_vpc.main
  Description: Creates the primary VPC using the provided CIDR block.
*/
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(
    local.merged_tags, // Use merged tags from tags.tf
    { Name = "${var.project_name}-${var.environment_name}-vpc" }
  )
}

/*
  Resource: aws_subnet.public
  Description: Creates public subnets within the VPC. These subnets are configured
               to assign public IP addresses to instances.
*/
resource "aws_subnet" "public" {
  count             = length(var.public_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    local.merged_tags,
    { Name = "${var.project_name}-${var.environment_name}-public-${count.index}" }
  )
}

/*
  Resource: aws_subnet.private
  Description: Creates private subnets within the VPC. These subnets do not
               automatically assign public IPs, making them suitable for internal resources.
*/
resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    local.merged_tags,
    { Name = "${var.project_name}-${var.environment_name}-private-${count.index}" }
  )
}

/*
  Resource: aws_internet_gateway.igw
  Description: Creates an Internet Gateway for the VPC to allow public subnets 
               to access the internet.
*/
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.merged_tags,
    { Name = "${var.project_name}-${var.environment_name}-igw" }
  )
}

/*
  Resource: aws_eip.nat
  Description: Allocates an Elastic IP address for the NAT Gateway.
  Note: We use `domain = "vpc"` per provider recommendations.
*/
resource "aws_eip" "nat" {
  domain = "vpc"

  tags = merge(
    local.merged_tags,
    { Name = "${var.project_name}-${var.environment_name}-eip" }
  )
}

/*
  Resource: aws_nat_gateway.nat
  Description: Creates a NAT Gateway in the first public subnet. This allows 
               instances in private subnets to access the internet for outbound traffic.
*/
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    local.merged_tags,
    { Name = "${var.project_name}-${var.environment_name}-nat" }
  )
}

/*
  Resource: aws_route_table.public
  Description: Creates a public route table that directs all outbound traffic 
               (0.0.0.0/0) to the Internet Gateway.
*/
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(
    local.merged_tags,
    { Name = "${var.project_name}-${var.environment_name}-public-rt" }
  )
}

/*
  Resource: aws_route_table_association.public
  Description: Associates the public route table with each public subnet.
*/
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

/*
  Resource: aws_route_table.private
  Description: Creates a private route table that directs all outbound traffic 
               (0.0.0.0/0) to the NAT Gateway.
*/
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = merge(
    local.merged_tags,
    { Name = "${var.project_name}-${var.environment_name}-private-rt" }
  )
}

/*
  Resource: aws_route_table_association.private
  Description: Associates the private route table with each private subnet.
*/
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
