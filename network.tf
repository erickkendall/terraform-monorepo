# Fetch available AZs in the region
data "aws_availability_zones" "available" {
  state = "available"
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Create public subnets
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidr_blocks)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project_name}-public-subnet-${count.index + 1}"
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidr_blocks)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  tags = {
    Name = "${var.project_name}-private-subnet-${count.index + 1}"
  }
}

# Create NAT Gateways
resource "aws_nat_gateway" "main" {
  count         = min(length(var.public_subnet_cidr_blocks), 2)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  tags = {
    Name = "${var.project_name}-nat-gateway-${count.index + 1}"
  }
}

# Create Elastic IPs for NAT Gateways
resource "aws_eip" "nat" {
  count = min(length(var.public_subnet_cidr_blocks), 2)
  vpc   = true
  tags = {
    Name = "${var.project_name}-nat-eip-${count.index + 1}"
  }
}

# Create route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

# Create route table for private subnets
resource "aws_route_table" "private" {
  count  = min(length(aws_subnet.private), 2)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main[count.index].id
  }

  tags = {
    Name = "${var.project_name}-private-rt-${count.index + 1}"
  }
}

# Associate public subnets with the public route table
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Associate private subnets with the private route tables
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

locals {
  nacl_rules = {
    http = {
      port        = 80
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      rule_number = 100
    }
    https = {
      port        = 443
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      rule_number = 110
    }
    ephemeral_inbound = {
      from_port   = 1024
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      rule_number = 120
    }
    ephemeral_outbound = {
      from_port   = 1024
      to_port     = 65535
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      rule_number = 130
    }
  }

  sg_rules = {
    http = {
      port        = 80
      protocol    = "tcp"
      description = "Allow HTTP traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
    https = {
      port        = 443
      protocol    = "tcp"
      description = "Allow HTTPS traffic"
      cidr_blocks = ["0.0.0.0/0"]
    }
    ephemeral_inbound = {
      from_port   = 1024
      to_port     = 65535
      protocol    = "tcp"
      description = "Allow inbound traffic from client ephemeral ports"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

resource "aws_default_network_acl" "default" {
  default_network_acl_id = aws_vpc.main.id

  dynamic "ingress" {
    for_each = { for k, v in local.nacl_rules : k => v if k != "ephemeral_outbound" }
    content {
      protocol   = ingress.value.protocol
      rule_no    = ingress.value.rule_number
      action     = "allow"
      cidr_block = ingress.value.cidr_block
      from_port  = lookup(ingress.value, "from_port", lookup(ingress.value, "port", 0))
      to_port    = lookup(ingress.value, "to_port", lookup(ingress.value, "port", 0))
    }
  }

  dynamic "egress" {
    for_each = local.nacl_rules
    content {
      protocol   = egress.value.protocol
      rule_no    = egress.value.rule_number
      action     = "allow"
      cidr_block = egress.value.cidr_block
      from_port  = lookup(egress.value, "from_port", lookup(egress.value, "port", 0))
      to_port    = lookup(egress.value, "to_port", lookup(egress.value, "port", 0))
    }
  }

  tags = {
    Name = "${var.project_name}-default-nacl"
  }
}

resource "aws_security_group" "main" {
  name        = "${var.project_name}-sg"
  description = "Security group for ${var.project_name}"
  vpc_id      = aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.sg_rules
    content {
      description = ingress.value.description
      from_port   = lookup(ingress.value, "from_port", lookup(ingress.value, "port", 0))
      to_port     = lookup(ingress.value, "to_port", lookup(ingress.value, "port", 0))
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}