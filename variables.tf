variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_account_id" {}
variable "database_host" {}
variable "database_name" {}
variable "database_username" {}
variable "database_password" {}
variable "rails_master_key" {}
variable "app_image_uri" {}
variable "nginx_image_uri" {}

# 作成するリソースのプレフィックス
variable "r_prefix" {
  default = "sample"
}
