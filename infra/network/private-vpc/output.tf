output vpc_id {
    value = aws_vpc.private_vpc.id
}

output "public_subnets" {
    value = {
        for subnet in aws_subnet.public_subnets : subnet.availability_zone => subnet.id
    }
    
}

output "private_subnets" {
    value = {
        for subnet in aws_subnet.private_subnets : subnet.availability_zone => subnet.id
    }
}

output "default_security_group_id" {
    value = aws_vpc.private_vpc.default_security_group_id
}