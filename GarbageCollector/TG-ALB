#Target groups
resource "aws_lb_target_group" "WebApp-TG" { 
  name     = "WebApp-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.WebApp.id

  health_check {
    enabled             = true
    interval            = 30
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }
}

resource "aws_lb_target_group_attachment" "tg_attachment_a" {
  target_group_arn = aws_lb_target_group.WebApp-TG.arn
  count = var.instance_count
  target_id        = aws_instance.WebApp-WebServer[count.index].id
  port             = 80
}


# // ALB
# resource "aws_lb" "WebApp-ALB" {
#   name               = "WebApp-ALB"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.WebApp-HTTP-ALB-sg]
#   subnets            = [var.public_subnet_cidr_1,var.public_subnet_cidr_2]

#   tags = {
#     Environment = "dev"
#   }
# }

# // Listener
# resource "aws_lb_listener" "WebApp-ALB-Listener" {
#   load_balancer_arn = aws_lb.WebApp-ALB.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.WebApp-TG.arn
#   }
# }
