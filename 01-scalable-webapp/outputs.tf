output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.WebApp.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.PublicSubnet-1.id
}

output "public_subnet2_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.PublicSubnet-2.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.PrivateSubnet-1.id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.WebApp-IGW.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT gateway"
  value       = aws_nat_gateway.WebApp-NATGW.id
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.PublicRTB.id
}

output "private_route_table_id" {
  description = "The ID of the private route table"
  value       = aws_route_table.PrivateRTB.id
}


# output "alb_dns_name" {
#   description = "The DNS name of the ALB."
#   value       = aws_lb.WebApp-application-lb.dns_name
# }