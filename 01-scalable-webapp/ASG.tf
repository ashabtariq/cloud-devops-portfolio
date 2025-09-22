#############################
# LAUNCH TEMPLATE
#############################
resource "aws_launch_template" "WebApp-LaunchConfig" {
  name_prefix   = "WebApp-Webserver"
  image_id      = "ami-08982f1c5bf93d976" # Replace with your AMI ID
  instance_type = "t3.micro"
  #key_name      = "my-key-pair" # Replace with your key pair name
  network_interfaces {
    associate_public_ip_address = true
    #subnet_id                   = aws_subnet.PrivateSubnet-1.id
    security_groups = [aws_security_group.WebApp-EC2-sg.id] # Reference your security group
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WebApp-Webserver-AGS"
    }
  }
  user_data = base64encode(file("${path.module}/../UserDataScripts/yum-apache.sh"))
  # Path to your script file

}

#############################
# Auto-Scaling Group
#############################
resource "aws_autoscaling_group" "WebApp-ASG" {
  name             = "WebApp-ASG"
  desired_capacity = 1
  max_size         = 3
  min_size         = 1
  vpc_zone_identifier = [
    aws_subnet.PrivateSubnet-1.id,
    #aws_subnet.PrivateSubnet-2.id
  ]

  launch_template {
    id      = aws_launch_template.WebApp-LaunchConfig.id
    version = "$Latest"
  }

  health_check_type = "EC2"
  target_group_arns = [aws_lb_target_group.WebApp-TG.arn]

  tag {
    key                 = "Name"
    value               = "WebApp-ASG-instance"
    propagate_at_launch = true
  }
}


################################
# Auto-Scaling Group CPU Policy
################################
resource "aws_autoscaling_policy" "cpu_scaling_policy" {
  name                   = "cpu-scaling-policy"
  autoscaling_group_name = aws_autoscaling_group.WebApp-ASG.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0 # Target average CPU utilization at 50%
  }
}
