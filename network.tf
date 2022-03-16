resource "aws_vpc" "sample" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "sample"
  }
}

resource "aws_subnet" "sample_public" {
  count  = length(local.availability_zone_ids)
  vpc_id = aws_vpc.sample.id

  cidr_block        = cidrsubnet(aws_vpc.sample.cidr_block, 3, 0 + count.index * 2)
  availability_zone = data.aws_availability_zone.availables[count.index].name

  tags = {
    Name = "sample-public-subnet-${data.aws_availability_zone.availables[count.index].name_suffix}"
  }
}

resource "aws_subnet" "sample_private" {
  count  = length(local.availability_zone_ids)
  vpc_id = aws_vpc.sample.id

  cidr_block        = cidrsubnet(aws_vpc.sample.cidr_block, 3, 1 + 2 * count.index)
  availability_zone = data.aws_availability_zone.availables[count.index].name

  tags = {
    Name = "sample-private-subnet-${data.aws_availability_zone.availables[count.index].name_suffix}"
  }
}

resource "aws_internet_gateway" "sample_igw" {
  vpc_id = aws_vpc.sample.id

  tags = {
    Name = "sample-igw"
  }
}

resource "aws_eip" "sample_eip" {
  count = length(local.availability_zone_ids)
  vpc   = true
  tags = {
    Name = "sample-eip-${data.aws_availability_zone.availables[count.index].name_suffix}"
  }
}

resource "aws_nat_gateway" "sample_ngw" {
  count         = length(local.availability_zone_ids)
  subnet_id     = aws_subnet.sample_private[count.index].id
  allocation_id = aws_eip.sample_eip[count.index].id

  tags = {
    Name = "sample-ngw-${data.aws_availability_zone.availables[count.index].name_suffix}"
  }

  depends_on = [aws_internet_gateway.sample_igw]
}

resource "aws_route_table" "sample_public" {
  vpc_id = aws_vpc.sample.id
}

resource "aws_route" "sample_public" {
  route_table_id = aws_route_table.sample_public.id
  gateway_id = aws_internet_gateway.sample_igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "sample_public" {
  count         = length(local.availability_zone_ids)
  subnet_id = aws_subnet.sample_public[count.index].id
  route_table_id = aws_route_table.sample_public.id
}

resource "aws_route_table" "sample_private" {
  count         = length(local.availability_zone_ids)
  vpc_id = aws_vpc.sample.id
}

resource "aws_route" "sample_private" {
  count         = length(local.availability_zone_ids)
  route_table_id = aws_route_table.sample_private[count.index].id
  nat_gateway_id = aws_nat_gateway.sample_ngw[count.index].id
  destination_cidr_block = "0.0.0.0/0"
}


resource "aws_route_table_association" "sample_private" {
  count = length(local.availability_zone_ids)
  subnet_id = aws_subnet.sample_private[count.index].id
  route_table_id = aws_route_table.sample_private[count.index].id
}
