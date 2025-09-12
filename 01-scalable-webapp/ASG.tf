#############################
# LAUNCH TEMPLATE
#############################
resource "aws_launch_template" "WebApp-LaunchConfig" {
  name_prefix   = "WebApp-Webserver"
  image_id      = "ami-0425c7cd52f6b7613" # Replace with your AMI ID
  instance_type = "t3.micro"
  #key_name      = "my-key-pair" # Replace with your key pair name

  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.WebApp-HTTP-ALB-sg.id] # Reference your security group
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "WebApp-Webserver-AGS"
    }
  }
  #user_data     = file("${path.module}./UserDataScripts/ubuntu-apache.sh") # Path to your script file

}

#############################
# Auto-Scaling Group
#############################
resource "aws_autoscaling_group" "WebApp-ASG" {
  name = "WebApp-ASG"
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.PublicSubnet-1.id, aws_subnet.PublicSubnet-2.id] # Replace with your subnet IDs
  

  launch_template {
    id      = aws_launch_template.WebApp-LaunchConfig.id
    version = "$Latest" # Use the latest version of the launch template
  }

  health_check_type = "EC2"
  target_group_arns = [aws_lb_target_group.WebApp-TG.arn]
  
  # Other ASG configurations (health checks, termination policies, etc.)
  # ...
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