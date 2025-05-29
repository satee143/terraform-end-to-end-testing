resource "aws_instance" "frontend" {
  ami = data.aws_ami.joindevops.id # golden AMI
  vpc_security_group_ids = [data.aws_ssm_parameter.sg_id.value]
  instance_type = "t3.micro"
  subnet_id     = local.public_subnet_id
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-frontend"
    }
  )
}

resource "null_resource" "frontend" {
  # Changes to any instance of the instance requires re-provisioning
  triggers = {
    instance_id = aws_instance.frontend.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host     = aws_instance.frontend.public_ip
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "/Users/satheeshdoosa/PycharmProjects/terraform-end-to-end-testing/frontend/frontend.sh"
    destination = "/tmp/frontend.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/frontend.sh",
      "sudo sh /tmp/frontend.sh ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "frontend" {
  instance_id = aws_instance.frontend.id

  state = "stopped"
  depends_on = [null_resource.frontend]
}

resource "aws_ami_from_instance" "frontend" {
  name               = "${local.resource_name}-Frontend-Alb"
  source_instance_id = aws_instance.frontend.id

  depends_on = [aws_ec2_instance_state.frontend]
}

resource "null_resource" "frontend_delete" {

  triggers = {
    instance_id = aws_instance.frontend.id
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.frontend.id}"
  }

  depends_on = [aws_ami_from_instance.frontend]
}


resource "aws_launch_template" "dashboard-frontend" {
  name                                 = "${local.resource_name}-Frontend-Alb"
  description                          = var.description
  image_id                             = aws_ami_from_instance.frontend.id
  instance_type                        = var.instance_type
  vpc_security_group_ids = [local.sg_frontend]
  instance_initiated_shutdown_behavior = "terminate"
  update_default_version               = true
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${local.resource_name}-Frontend-Alb"
    }
  }

}

resource "aws_lb_target_group" "dashboard-frontend" {
  name                 = "${local.resource_name}-frontend"
  port                 = var.port_number
  protocol             = var.protocol
  vpc_id               = local.vpc_id
  deregistration_delay = 60
  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
    path                = "/"
    matcher             = "200-299"
    interval            = 10
  }
  tags = merge(var.common_tags,
    { Name = "${local.resource_name}-frontend" })

}

resource "aws_autoscaling_group" "dashboard-frontend" {
  name = "${local.resource_name}-frontend"
  launch_template {
    id      = aws_launch_template.dashboard-frontend.id
    version = aws_launch_template.dashboard-frontend.latest_version
  }
  target_group_arns = [aws_lb_target_group.dashboard-frontend.arn]
  max_size                  = 10
  min_size                  = 1
  desired_capacity          = 2
  health_check_type         = "ELB"
  health_check_grace_period = 180
  vpc_zone_identifier       = local.public_subnets


  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }
  tag {
    key                 = "Name"
    value               = "${local.resource_name}-Frontend-Alb"
    propagate_at_launch = true
  }

  timeouts {
    delete = "10m"
  }
}

module "alb" {
  source                     = "terraform-aws-modules/alb/aws"
  internal = false
  # expense-dev-app-alb
  name                       = "${var.project_name}-${var.environment}-web-alb"
  vpc_id                     = data.aws_ssm_parameter.vpc_id.value
  subnets                    = local.public_subnets
  create_security_group      = false
  security_groups = [local.sg_alb_frontend]
  enable_deletion_protection = false
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-app-alb"
    }
  )
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = module.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = local.web_alb_certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from frontend APP ALB</h1>"
      status_code  = "200"
    }
  }
}


resource "aws_route53_record" "web_alb" {
  zone_id = var.zone_id
  name    = "dashboard-${var.environment}.${var.domain_name}"
  type    = "A"

  # these are ALB DNS name and zone information
  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = false
  }
}

resource "aws_lb_listener_rule" "backend" {
  listener_arn = aws_lb_listener.https.arn

  priority = 10

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dashboard-frontend.arn
  }

  condition {
    host_header {
      values = ["dashboard-${var.environment}.${var.domain_name}"]
    }
  }
}