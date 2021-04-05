# App
resource "aws_ecr_repository" "sample_app" {
  name                 = "${var.r_prefix}-app"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "sample_app_lifecycle_policy" {
  repository = aws_ecr_repository.sample_app.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Delete images when count is more than 500",
        "selection": {
          "tagStatus": "any",
          "countType": "imageCountMoreThan",
          "countNumber": 500
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
EOF
}

# Nginx
resource "aws_ecr_repository" "sample_nginx" {
  name = "${var.r_prefix}-nginx"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
