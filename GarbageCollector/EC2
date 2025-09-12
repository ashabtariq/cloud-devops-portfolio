# -------------------------
# AMI Lookup (Ubuntu 20.04 LTS)
# -------------------------
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}


# -------------------------
# Public EC2 (Public Subnet)
# -------------------------

resource "aws_instance" "WebApp-WebServer" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  count  = var.instance_count
  subnet_id     = aws_subnet.PublicSubnet-1.id
  associate_public_ip_address = true
  #key_name      = aws_key_pair.WebApp-ec2_key.key_name
  vpc_security_group_ids = [aws_security_group.WebApp-HTTP-ALB-sg.id]
  user_data     = file("${path.module}./UserDataScripts/ubuntu-apache.sh") # Path to your script file


  tags = {
    Name = "WebApp-WebServer-${count.index}"
  }
}
