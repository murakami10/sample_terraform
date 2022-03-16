resource "aws_vpc" "sample" {
    cidr_block           = "10.0.0.0/16"
    enable_dns_support   = true
    enable_dns_hostnames = true

    tags = {
        Name = "sample"
    }
}

resource "aws_subnet" "sample_public" {
    count = length(local.availability_zone_ids)
    vpc_id = aws_vpc.sample.id

    cidr_block = cidrsubnet(aws_vpc.sample.cidr_block, 3, 0 + count.index*2)
    availability_zone = data.aws_availability_zone.availables[count.index].name

    tags = {
        Name = "sample-public-subnet-${data.aws_availability_zone.availables[count.index].name_suffix}"
    }
}

resource "aws_subnet" "sample_private" {
    count = length(local.availability_zone_ids)
    vpc_id = aws_vpc.sample.id

    cidr_block = cidrsubnet(aws_vpc.sample.cidr_block, 3, 1 + 2*count.index)
    availability_zone = data.aws_availability_zone.availables[count.index].name

    tags = {
        Name = "sample-private-subnet-${data.aws_availability_zone.availables[count.index].name_suffix}"
    }
}

#resource "aws_internet_gateway" "sample_public_1a_igw" {
#    vpc_id = aws_vpc.sample.id
#}
#
#resource "aws_route_table" "sample_public_1a" {
#    vpc_id = aws_vpc.sample.id
#}
#
#resource "aws_route" "sample_public_1a" {
#    route_table_id = aws_route_table.sample_public_1a.id
#    gateway_id = aws_internet_gateway.sample_public_1a_igw.id
#    destination_cidr_block = "0.0.0.0/0"
#}
#
#resource "aws_route_table_association" "sample_public_1a" {
#    subnet_id = aws_subnet.sample_public_1a.id
#    route_table_id = aws_route_table.sample_public_1a.id
#}