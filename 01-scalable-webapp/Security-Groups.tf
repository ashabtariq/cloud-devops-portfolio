# -------------------------
# Security Groups
# -------------------------

# Public SSH Access to EC2 <-- TESTING ONLY !!!!!!!!!!!!!!
resource "aws_security_group" "WebApp-SSH-Access-SG" {
  name        = "WebApp-SSH-sg"
  description = "Allow public SSH Access"
  vpc_id      = aws_vpc.WebApp.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # <-- Replace with your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebApp-SSH-Access-SG"
  }
}



#SECURITY GROUP FOR ALB
resource "aws_security_group" "WebApp-HTTP-ALB-sg" {
  name        = "WebApp-HTTP-ALB-sg"
  description = "Allow public HTTP Access"
  vpc_id      = aws_vpc.WebApp.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # <-- Replace with your IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "WebApp-HTTP-ALB-sg"
  }
}


# -------------------------
# Key Pair
# -------------------------
resource "aws_key_pair" "WebApp-ec2_key" {
  key_name   = "WebApp-key"
  public_key = file(var.public_key_path) # <-- FROM VARIABLE FILE
}