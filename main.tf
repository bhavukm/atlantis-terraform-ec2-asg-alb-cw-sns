# Data sources
data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnet" "selected" {
  for_each = toset(var.subnet_ids)
  id       = each.value
}

data "aws_security_group" "selected" {
  for_each = toset(var.security_group_ids)
  id       = each.value
}

data "aws_ami" "amazon_linux2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Launch Template
resource "aws_launch_template" "demolt" {
  name          = "${local.project_name}-lt"
  image_id      = data.aws_ami.amazon_linux2.id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    security_groups = var.security_group_ids
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 8
      volume_type = "gp3"
    }
  }

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  tag_specifications {
    resource_type = "instance"
    tags = merge(local.common_tags, {
      Name = "${local.project_name}-instance"
    })
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "demoasg" {
  name                = "${local.project_name}-asg"
  min_size            = var.asg_min_size
  desired_capacity    = var.asg_desired_capacity
  max_size            = var.asg_max_size
  vpc_zone_identifier = var.subnet_ids

  launch_template {
    id      = aws_launch_template.demolt.id
    version = "$Latest"
  }

  tags = [
    {
      key                 = "Name"
      value               = "${local.project_name}-asg"
      propagate_at_launch = true
    }
  ]
}

# ALB
resource "aws_lb" "alb" {
  name               = "${local.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids
  tags               = local.common_tags
}

resource "aws_lb_target_group" "lt_ag" {
  name        = "${local.project_name}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.main.id
  target_type = "instance"
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lt_ag.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.demoasg.id
  alb_target_group_arn   = aws_lb_target_group.lt_ag.arn
}

# Scaling Policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${local.project_name}-scaleup"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.demoasg.name
}

# CloudWatch Alarm
resource "aws_cloudwatch_metric_alarm" "cpuutilization_alarm" {
  alarm_name          = "${local.project_name}-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = var.alarm_threshold
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn, aws_sns_topic.cpu.arn]

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.demoasg.name
  }
}

# SNS
resource "aws_sns_topic" "cpu" {
  name         = "${local.project_name}-cpu-topic"
  display_name = "CPU Utilization Alert"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.cpu.arn
  protocol  = "email-json"
  endpoint  = var.notification_email
}
