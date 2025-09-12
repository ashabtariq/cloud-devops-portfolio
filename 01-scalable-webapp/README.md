# Project: Scalable Web App on AWS with Terraform

## Problem
Businesses need web applications that can handle traffic spikes, stay highly available, and remain cost-efficient.

## Solution
- Deployed a 3-tier architecture using AWS (VPC, ALB, Auto Scaling EC2, RDS, S3).
- CloudFront CDN + Route53 for fast global content delivery and DNS management.
- Fully automated infrastructure using Terraform modules.
- Implemented cost optimizations with spot instances and S3 lifecycle policies.

### Architecture Diagram
![Architecture](./diagrams/architecture.png)

### Outcome
- Application scales automatically to handle high traffic.
- Multi-AZ setup ensures high availability.
- Estimated cost reduction: 25–30% using spot instances and storage optimizations.

