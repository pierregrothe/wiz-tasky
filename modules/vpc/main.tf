resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = merge(
    var.tags,
    { Name = "${var.project_name}-vpc" }
  )
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnets_cidr)
  vpc_id           = aws_vpc.main.id
  cidr_block       = var.public_subnets_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    var.tags,
    { Name = "${var.project_name}-public-${count.index}" }
  )
}

resource "aws_subnet" "private" {
  count             = length(var.private_subnets_cidr)
  vpc_id           = aws_vpc.main.id
  cidr_block       = var.private_subnets_cidr[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(
    var.tags,
    { Name = "${var.project_name}-private-${count.index}" }
  )
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    { Name = "${var.project_name}-igw" }
  )
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.tags,
    { Name = "${var.project_name}-nat" }
  )
}
