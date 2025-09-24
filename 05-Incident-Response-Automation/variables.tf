variable "project_name" {
  description = "Project name prefix for tagging"
  type        = string
  default     = "AutomatedIT"
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

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}


variable "s3-bucket-name" {
  description = "Bucket name to get uploaded images"
  type        = string
  default     = "iam-logs-ashabTariq"
}

