resource "aws_internet_gateway" "sample_igw" {
  vpc_id = aws_vpc.sample_vpc.id

  tags = {
    Name = "${var.r_prefix}-igw"
  }
}
