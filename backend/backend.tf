resource "aws_instance" "backend" {
  ami = data.aws_ami.joindevops.id # golden AMI
  vpc_security_group_ids = [data.aws_ssm_parameter.sg_id.value]
  instance_type = "t3.micro"
  subnet_id     = local.private_subnet_id
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-backend"
    }
  )
}

resource "null_resource" "backend" {
  # Changes to any instance of the instance requires re-provisioning
  triggers = {
    instance_id = aws_instance.backend.id
  }

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    host     = aws_instance.backend.private_ip
    type     = "ssh"
    user     = "ec2-user"
    password = "DevOps321"
  }

  provisioner "file" {
    source      = "/Users/satheeshdoosa/PycharmProjects/terraform-end-to-end-testing/backend/backend.sh"
    destination = "/tmp/backend.sh"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "chmod +x /tmp/backend.sh",
      "sudo sh /tmp/backend.sh ${var.environment}"
    ]
  }
}

resource "aws_ec2_instance_state" "backend" {
  instance_id = aws_instance.backend.id
  state       = "stopped"
  depends_on = [null_resource.backend]
}

resource "aws_ami_from_instance" "backend" {
  name               = local.resource_name
  source_instance_id = aws_instance.backend.id
  depends_on = [aws_ec2_instance_state.backend]
}

resource "null_resource" "backend_delete" {

  triggers = {
    instance_id = aws_instance.backend.id
  }

  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.backend.id}"
  }

  depends_on = [aws_ami_from_instance.backend]
}


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
    triggers = ["launch_template"]
  }
}

module "alb" {
  source                     = "terraform-aws-modules/alb/aws"
  internal = true
  # expense-dev-app-alb
  name                       = "${var.project_name}-${var.environment}-app-alb"
  vpc_id                     = data.aws_ssm_parameter.vpc_id.value
  subnets                    = local.private_subnets
  create_security_group      = false
  security_groups = [local.sg_alb_backend]
  enable_deletion_protection = false
  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-app-alb"
    }
  )
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/html"
      message_body = "<h1>Hello, I am from backend APP ALB</h1>"
      status_code  = "200"
    }
  }
}


resource "aws_route53_record" "app_alb" {
  zone_id = var.zone_id
  name    = "*.app-dev.${var.domain_name}"
  type    = "A"

  # these are ALB DNS name and zone information
  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = false
  }
}