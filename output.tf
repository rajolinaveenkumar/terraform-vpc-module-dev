output "vpc_info" {
  value = aws_vpc.main_vpc
}

output "igw_info" {
  value = aws_internet_gateway.igw
}



output "az_info" {
    value = data.aws_availability_zones.available.names
}

output "default_vpc_info" {
  value = data.aws_vpc.default_vpc_info
}

data "aws_route_table" "main" {
  vpc_id = local.default_vpc_id
  filter {
    name   = "association.main"
    values = ["true"]
  }
}