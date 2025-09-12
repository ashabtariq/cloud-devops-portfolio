# -------------------------
# Application Load Balancer
# -------------------------

resource "aws_lb" "WebApp-application-lb" {
    name            = "WebApp-application-lb"
    internal        = false
    ip_address_type     = "ipv4"
    load_balancer_type = "application"
    security_groups = [aws_security_group.WebApp-HTTP-ALB-sg.id]
    subnets         = [aws_subnet.PublicSubnet-1.id,aws_subnet.PublicSubnet-2.id]
    tags = {
        Name = "WebApp-application-lb"
    }
}



#---------------------------
# TARGET GROUP
#----------------------
resource "aws_lb_target_group" "WebApp-TG" {
  name     = "WebApp-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.WebApp.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
  }

  tags = {
    Name = "WebApp-TG"
  }
}

resource "aws_lb_listener" "WebApp-TG-Listener" {
  load_balancer_arn = aws_lb.WebApp-application-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.WebApp-TG.arn
  }
}