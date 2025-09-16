variable "project_name" {
  description = "Project name prefix for tagging"
  type        = string
  default     = "Serverless-Url-Shortner"
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

variable "tableName" {
  description = "Dynamo DB Table Name"
  type        = string
  default     = "url_shortner"
}

