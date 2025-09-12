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

resource "aws_autoscaling_group" "WebApp-ASG" {
  desired_capacity    = 1
  max_size            = 3
  min_size            = 1
  vpc_zone_identifier = [aws_subnet.PublicSubnet-1.id, aws_subnet.PublicSubnet-2.id] # Replace with your subnet IDs
  

  launch_template {
    id      = aws_launch_template.WebApp-LaunchConfig.id
    version = "$Latest" # Use the latest version of the launch template
  }

  health_check_type = "EC2"

  # Other ASG configurations (health checks, termination policies, etc.)
  # ...
}