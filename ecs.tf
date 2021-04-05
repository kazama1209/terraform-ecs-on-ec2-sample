resource "aws_ecs_cluster" "sample_cluster" {
  name               = "${var.r_prefix}-cluster"
  capacity_providers = [aws_ecs_capacity_provider.sample_ecs_capacity_provider.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.sample_ecs_capacity_provider.name
    base              = 0
    weight            = 1
  }
}

resource "aws_ecs_task_definition" "sample_app_nginx" {
  family                   = "${var.r_prefix}-app-nginx"
  container_definitions    = templatefile("./task-definitions/app-nginx.json",
                                {
                                  app_image_uri     = var.app_image_uri,
                                  nginx_image_uri   = var.nginx_image_uri,
                                  database_host     = var.database_host,
                                  database_name     = var.database_name,
                                  database_password = var.database_password,
                                  database_username = var.database_username,
                                  rails_master_key  = var.rails_master_key
                                }
                             )

  task_role_arn            = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  execution_role_arn       = "arn:aws:iam::${var.aws_account_id}:role/ecsTaskExecutionRole"
  cpu                      = 512
  memory                   = 1024
  requires_compatibilities = ["EC2"]
}


resource "aws_ecs_service" "sample_service" {
  name            = "${var.r_prefix}-service"
  task_definition = aws_ecs_task_definition.sample_app_nginx.arn
  cluster         = aws_ecs_cluster.sample_cluster.arn
  desired_count   = 1

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.sample_ecs_capacity_provider.name
    weight = 1
    base = 0
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.sample_alb_tg.arn
    container_name   = "nginx"
    container_port   = 80
  }
}

resource "aws_ecs_capacity_provider" "sample_ecs_capacity_provider" {
  name = "${var.r_prefix}-ecs-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.sample_auto_scalling_group.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 100
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}
