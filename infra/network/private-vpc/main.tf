resource "aws_vpc" "private_vpc" {
    cidr_block = local.vpc_config.vpc.cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "${terraform.workspace}_private_vpc"
    }
}

resource "aws_internet_gateway" "public_vpc_igw" {
    vpc_id = aws_vpc.private_vpc.id

    tags = {
        Name = "${terraform.workspace}_private_vpc_igw"
    }
}

resource "aws_eip" "nat_eip" {
    vpc = true
    tags = {
        Name = "${terraform.workspace}_nat_eip"
    }
}

resource "aws_nat_gateway" "private_vpc_nat" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.public_subnets[local.vpc_azs[0]].id

    tags = {
        Name = "${terraform.workspace}_nat_gateway"
    }
}

resource "aws_subnet" "public_subnets" {
    for_each = local.public_subnets

    vpc_id = aws_vpc.private_vpc.id
    cidr_block = each.value
    availability_zone = each.key
    map_public_ip_on_launch = true

    tags = {
        Name = "${terraform.workspace}_${each.value}_public_subnet"
    }
}

resource "aws_subnet" "private_subnets" {
    for_each = local.private_subnets

    vpc_id = aws_vpc.private_vpc.id
    cidr_block = each.value
    availability_zone = each.key
    map_public_ip_on_launch = true

    tags = {
        Name = "${terraform.workspace}_${each.value}_private_subnet"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.private_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.public_vpc_igw.id
    }

    tags= { 
        Name = "${terraform.workspace}_public_rt"
    }
}

resource "aws_route_table" "private_rt" {
    vpc_id = aws_vpc.private_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.private_vpc_nat.id
    }

    tags = { 
        Name = "${terraform.workspace}_public_rt"
    }
}

resource "aws_route_table_association" "public_mapping" {
    for_each = aws_subnet.public_subnets
    route_table_id = aws_route_table.public_rt.id       

    subnet_id = each.value.id
}

resource "aws_route_table_association" "private_mapping" {
    for_each = aws_subnet.private_subnets
    route_table_id = aws_route_table.private_rt.id

    subnet_id = each.value.id
}

