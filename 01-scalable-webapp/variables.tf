variable "project_name" {
  description = "Project name prefix for tagging"
  type        = string
  default     = "WebApp"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-1"
}

variable "AZ-A" {
  description = "Availability Zone for the subnets"
  type        = string
  default     = "us-east-1a"
}

variable "AZ-B" {
  description = "Availability Zone for the subnets"
  type        = string
  default     = "us-east-1b"
}


variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"                                                                                                      
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr_1" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string                                                                                                                                                                                                
  default     = "10.0.11.0/24"
}


variable "public_key_path" {
  description = "Path to your SSH public key"
  type        = string
  default     = "/home/ashab/.ssh/id_ed25519.pub"
}

variable "instance_count" {
  description = "The number of EC2 instances to create."
  type        = number
  default     = 2
}
