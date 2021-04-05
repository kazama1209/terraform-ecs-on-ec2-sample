resource "aws_route_table" "sample_public_rt" {
  vpc_id = aws_vpc.sample_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.sample_igw.id
  }

  tags = {
    Name = "${var.r_prefix}-public-rt"
  }
}

resource "aws_route_table_association" "sample_public_subnet_1a_rt_assoc" {
  subnet_id      = aws_subnet.sample_public_subnet_1a.id
  route_table_id = aws_route_table.sample_public_rt.id
}

resource "aws_route_table_association" "public_1c_rt_assoc" {
  subnet_id      = aws_subnet.sample_public_subnet_1c.id
  route_table_id = aws_route_table.sample_public_rt.id
}
