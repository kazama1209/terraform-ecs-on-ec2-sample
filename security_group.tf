# アプリ全体用
resource "aws_security_group" "sample_sg_app" {
  name        = "${var.r_prefix}-sg-app"
  description = "${var.r_prefix}-sg-app"
  vpc_id      = "${aws_vpc.sample_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.r_prefix}-sg-app"
  }
}

# ロードバランサー用
resource "aws_security_group" "sample_sg_alb" {
  name        = "${var.r_prefix}-sg-alb"
  description = "${var.r_prefix}-sg-alb"
  vpc_id      = "${aws_vpc.sample_vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.r_prefix}-sg-alb"
  }
}

# データベース用
resource "aws_security_group" "sample_sg_db" {
  name        = "${var.r_prefix}-sg-db"
  description = "${var.r_prefix}-sg-db"
  vpc_id      = aws_vpc.sample_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.r_prefix}-sg-db"
  }
}

# ssh接続用
resource "aws_security_group" "sample_sg_ssh" {
  name        = "${var.r_prefix}-sg-ssh"
  description = "${var.r_prefix}-sg-ssh"
  vpc_id      = aws_vpc.sample_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.r_prefix}-sg-ssh"
  }
}
