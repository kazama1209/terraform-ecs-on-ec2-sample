resource "aws_alb" "sample_alb" {
  name                       = "${var.r_prefix}-alb"
  security_groups            = [aws_security_group.sample_sg_alb.id]
  
  subnets                    = [
    aws_subnet.sample_public_subnet_1a.id,
    aws_subnet.sample_public_subnet_1c.id
  ]

  internal                   = false
  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.sample_alb_logs.bucket
  }
}

resource "aws_alb_target_group" "sample_alb_tg" {
  name                 = "${var.r_prefix}-alb-tg"
  port                 = 80
  depends_on           = [aws_alb.sample_alb]
  target_type          = "instance"
  protocol             = "HTTP"
  vpc_id               = aws_vpc.sample_vpc.id
  deregistration_delay = 15

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = 200
  }
}

resource "aws_alb_listener" "sample_alb_listener" {
  port              = "80"
  protocol          = "HTTP"

  load_balancer_arn = aws_alb.sample_alb.arn

  default_action {
    target_group_arn = aws_alb_target_group.sample_alb_tg.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "sample_alb_listener_rule" {
  depends_on         = [aws_alb_target_group.sample_alb_tg]
  listener_arn       = aws_alb_listener.sample_alb_listener.arn
  priority           = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.sample_alb_tg.arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}
