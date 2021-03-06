output "vpc" {
    value = aws_vpc.vpc
}

output "subnet" {
    value = aws_subnet.public_subnet
}

output "sg" {
    value = aws_security_group.public_http_sg
}