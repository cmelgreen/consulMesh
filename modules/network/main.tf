resource "aws_vpc" "vpc" {
    cidr_block              = "10.0.0.0/16"
    enable_dns_support      = true
    enable_dns_hostnames    = true
}

resource "aws_subnet" "public_subnet" {
    vpc_id                  = aws_vpc.vpc.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "us-east-1a"
}

resource "aws_security_group" "public_http_sg" {
    name        = "public_http_sg"

    vpc_id = aws_vpc.vpc.id

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8300
      to_port     = 8300
      protocol   = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8301
      to_port     = 8301
      protocol   = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8302
      to_port     = 8302
      protocol   = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8400
      to_port     = 8400
      protocol   = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8500
      to_port     = 8500
      protocol   = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8501
      to_port     = 8501
      protocol   = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8600
      to_port     = 8600
      protocol   = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8300
      to_port     = 8300
      protocol   = "udp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8301
      to_port     = 8301
      protocol   = "udp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8302
      to_port     = 8302
      protocol   = "udp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8400
      to_port     = 8400
      protocol   = "udp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8500
      to_port     = 8500
      protocol   = "udp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8501
      to_port     = 8501
      protocol   = "udp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 8600
      to_port     = 8600
      protocol   = "udp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 5432
      to_port     = 5432
      protocol   = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    ingress {
      from_port   = 20000
      to_port     = 21255
      protocol   = "tcp"
      cidr_blocks  = ["0.0.0.0/0"]
    }

    egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id          = aws_vpc.vpc.id
}

resource "aws_route_table" "public_rtb" {
    vpc_id          = aws_vpc.vpc.id

    route {
        cidr_block  = "0.0.0.0/0"
        gateway_id  = aws_internet_gateway.igw.id
    }
}

resource "aws_route_table_association" "public_route_assosciation" {
    route_table_id  = aws_route_table.public_rtb.id
    subnet_id       = aws_subnet.public_subnet.id
}