resource "aws_vpc" "main_vpc" {
    cidr_block = var.cidr_range
    enable_dns_hostnames = var.enable_dns_hostnames
    instance_tenancy = "default" 
    # "default" --> EC2 instances run on shared hardware (normal, cheaper) 
    # "dedicated" --> EC2 instances run on dedicated hardware (costlier, isolated)

    tags = merge(
        var.vpc_tags,
        var.common_tags,
        {
            Name            =  "${local.resource_name}-vpc"
            Module-Owner    =  "Naveen Rajoli"
            Module          =  "vpc"
            Terraform       = true
        }
    )

}

# Internet Gateway
resource "aws_internet_gateway" "igw"{
    vpc_id = aws_vpc.main_vpc.id

    tags = merge(
        var.igw_tags,
        var.common_tags,
        {
            Name            =  "${local.resource_name}-igw"
            Module-Owner    =  "Naveen Rajoli"
            Terraform       = true
        }
    )
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
    count = length(var.public_subnet_cidr)
    vpc_id     = aws_vpc.main_vpc.id
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = local.az_names[count.index]

    tags = merge(
        var.public_subnet_tags,
        var.common_tags,
        {
            Name            =  "${local.resource_name}-public-${local.az_names[count.index]}"
            Module-Owner    =  "Naveen Rajoli"
            Terraform       = true
        }
    )

}

# Private Subnet 
resource "aws_subnet" "private_subnet" {
    count = length(var.private_subnet_cidr)
    vpc_id     = aws_vpc.main_vpc.id
    cidr_block = var.private_subnet_cidr[count.index]
    availability_zone = local.az_names[count.index]

    tags = merge(
        var.private_subnet_tags,
        var.common_tags,
        {
            Name            =  "${local.resource_name}-private-${local.az_names[count.index]}"
            Module-Owner    =  "Naveen Rajoli"
            Terraform       = true
        }
    )

}

# Database Subnet
resource "aws_subnet" "database_subnet" {
    count = length(var.database_subnet_cidr)
    vpc_id     = aws_vpc.main_vpc.id
    cidr_block = var.database_subnet_cidr[count.index]
    availability_zone = local.az_names[count.index]

    tags = merge(
        var.database_subnet_tags,
        var.common_tags,
        {
            Name            =  "${local.resource_name}-database-${local.az_names[count.index]}"
            Module-Owner    =  "Naveen Rajoli"
            Terraform       = true
        }
    )

}

# Elastic IP
resource "aws_eip" "eip" {
  domain = "vpc"

  tags = merge(
        var.eip_tags,
        var.common_tags,
        {
            Name            =  "${local.resource_name}-database}"
            Module-Owner    =  "Naveen Rajoli"
            Terraform       = true
        }
    )
}

# NAT gateways
resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
  
  tags = merge(
        var.ngw_tags,
        var.common_tags,
        {
            Name            =  "${local.resource_name}-ngw"
            Module-Owner    =  "Naveen Rajoli"
            Terraform       = true
        }
    )

}

# Public Route Table
resource "aws_route_table" "public_route" {
    vpc_id = aws_vpc.main_vpc.id

    tags = merge(
        var.public_route_tags,
        var.common_tags,
        {
            Name            =  "${local.resource_name}-public"
            Module-Owner    =  "Naveen Rajoli"
            Terraform       = true
        }
    )


}

# Private Route Table
resource "aws_route_table" "private_route" {
    vpc_id = aws_vpc.main_vpc.id

    tags = merge(
        var.private_route_tags,
        var.common_tags,
        {
            Name            =  "${local.resource_name}-private"
            Module-Owner    =  "Naveen Rajoli"
            Terraform       = true
        }
    )


}

# Database Route Table
resource "aws_route_table" "database_route" {
    vpc_id = aws_vpc.main_vpc.id

    tags = merge(
        var.database_route_tags,
        var.common_tags,
        {
            Name            =  "${local.resource_name}-database"
            Module-Owner    =  "Naveen Rajoli"
            Terraform       = true
        }
    )


}

# Public Route table association
resource "aws_route_table_association" "pub_assocation" {
  count = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route.id
}

# Private Route table association
resource "aws_route_table_association" "private_assocation" {
  count = length(aws_subnet.private_subnet)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route.id
}

# Database Route table association
resource "aws_route_table_association" "database_assocation" {
  count = length(aws_subnet.database_subnet)
  subnet_id      = aws_subnet.database_subnet[count.index].id
  route_table_id = aws_route_table.database_route.id
}

# public route table to internet gateway
resource "aws_route" "rpub_igw" {
  route_table_id            = aws_route_table.public_route.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

#private route table to nat gatewasy
resource "aws_route" "rpri_ngw" {
  route_table_id            = aws_route_table.private_route.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id             = aws_nat_gateway.ngw.id
}

#database route table to nat gatewasy
resource "aws_route" "rdatabase_ngw" {
  route_table_id            = aws_route_table.database_route.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id             = aws_nat_gateway.ngw.id
}

