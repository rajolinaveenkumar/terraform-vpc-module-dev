resource "aws_vpc_peering_connection" "vpc_peering" {
  count = var.is_peering_required ? 1 : 0
  
  vpc_id        = aws_vpc.main_vpc.id # Requester
  peer_vpc_id   = local.default_vpc_id # Accepter
  auto_accept   = true

    tags = merge(
        var.vpc_peering_tags,
        var.common_tags,
        {
            Name            =  "${local.resource_name}-peering"
            Module-Owner    =  "Naveen Rajoli"
            Terraform       = true
        }
    )

}

resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0

  route_table_id            = aws_route_table.public_route.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id # we can provide this one also [count.index]

}

resource "aws_route" "private_peering" {
  count = var.is_peering_required ? 1 : 0

  route_table_id            = aws_route_table.private_route.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id # we can provide this one also [count.index]

}

resource "aws_route" "database_peering" {
  count = var.is_peering_required ? 1 : 0

  route_table_id            = aws_route_table.database_route.id
  destination_cidr_block    = local.default_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id # we can provide this one also [count.index]

}


resource "aws_route" "default_vpc_peering" {
  count = var.is_peering_required ? 1 : 0

  route_table_id            = data.aws_route_table.main.route_table_id
  destination_cidr_block    = var.cidr_range
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering[0].id # we can provide this one also [count.index]

}