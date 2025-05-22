resource "aws_launch_template" "dashboard" {
  name                                 = local.resource_name
  description                          = var.description
  image_id                             = ""
  instance_type                        = var.instance_type
  vpc_security_group_ids = [local.sg_backend]
  instance_initiated_shutdown_behavior = "terminate"
  update_default_version               = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = local.resource_name
    }
  }

}

resource "aws_lb_target_group" "dashboard" {
  name     = local.resource_name
  port     = var.port_number
  protocol = var.protocol
  vpc_id   = local.vpc_id
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
    path                = "/health"
    matcher             = "200-299"
    interval            = 10
  }
  tags = merge(var.common_tags,
    { Name = local.resource_name })

}

resource "aws_autoscaling_group" "dashboard" {
  name = local.resource_name
  launch_template {
    id      = aws_launch_template.dashboard.id
    version = aws_launch_template.dashboard.latest_version
  }
  target_group_arns = [aws_lb_target_group.dashboard.arn]
  max_size            = 10
  min_size            = 1
  desired_capacity    = 2
  health_check_type   = "ELB"
  vpc_zone_identifier = local.private_subnets

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50

    }
    triggers = [aws_launch_template.dashboard]
  }
}