data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_autoscaling_group" "sample_auto_scalling_group" {
  name     = "${var.r_prefix}-auto-scalling-group"

  max_size = 10
  min_size = 0

  vpc_zone_identifier  = [
    aws_subnet.sample_public_subnet_1a.id,
    aws_subnet.sample_public_subnet_1c.id
  ]

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.sample_launch_template.id
        version            = "$Latest"
      }

      override {
        instance_type     = "t3.large"
        weighted_capacity = "1"
      }
      
      override {
        instance_type     = "t3.xlarge"
        weighted_capacity = "2"
      }
    }
    instances_distribution {
      on_demand_percentage_above_base_capacity = 0
    }
  }

  lifecycle {
    ignore_changes = [desired_capacity, tag]
  }

  default_cooldown = 60
}

resource "aws_launch_template" "sample_launch_template" {
  name                   = "${var.r_prefix}-auto-scalling-group"
  image_id               = data.aws_ssm_parameter.ecs_optimized_ami.value
  vpc_security_group_ids = [
    aws_security_group.sample_sg_app.id,
    aws_security_group.sample_sg_db.id,
    aws_security_group.sample_sg_ssh.id,
  ]

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 60
      volume_type = "gp2"
    }
  }

  ebs_optimized = true
  user_data = "${base64encode(file("./user_data.sh"))}"

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.r_prefix}-ecs-instance"
    }
  }

  tag_specifications {
    resource_type = "volume"
    tags = {
      Name    = "${var.r_prefix}-ecs-instance"
    }
  }

  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_agent.arn
  }
}
