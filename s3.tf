resource "aws_s3_bucket" "sample_alb_logs" {
  bucket = "${var.r_prefix}-20210405-alb-logs"
}
