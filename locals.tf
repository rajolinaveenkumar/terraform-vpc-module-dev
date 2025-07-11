locals {
    resource_name = "${var.project_name}-${var.environment}"
    az_names = slice(data.aws_availability_zones.available.names, 0, 2)
    default_vpc_id = data.aws_vpc.default_vpc_info.id
   default_vpc_cidr = data.aws_vpc.default_vpc_info.cidr_block
 
}

