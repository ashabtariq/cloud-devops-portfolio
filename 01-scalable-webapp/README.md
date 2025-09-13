# 🚀 Scalable Web Application on AWS with Terraform

## 📌 Project Overview
This project demonstrates how to design and deploy a **highly available, scalable, and cost-optimized web application** on AWS using **Terraform** for Infrastructure as Code (IaC).

The architecture follows a **3-tier design** (Presentation, Application, and Data layers) and includes advanced cloud features such as **Auto Scaling, CloudFront CDN, Route53 DNS, and Spot Instances** for cost efficiency.

---

## 🏗️ Architecture

![AWS Architecture Diagram](./Architecture%20Diagram.png)

**Key Components:**
- **VPC** with public & private subnets across multiple AZs for high availability.
- **Application Load Balancer (ALB)** to distribute traffic across EC2 instances.
- **Auto Scaling Group (ASG)** for dynamic scaling of the application layer.
- **Amazon RDS (Multi-AZ)** for relational database with automated backups. (Not Included in code)
- **Amazon S3** for static asset storage and application logs. (Not Included in code)
- **CloudFront CDN** for global content delivery with low latency. (Not Included in code)
- **Route 53** for DNS management and domain routing. (Not Included in code)
- **Terraform** to provision and manage all AWS resources with modular code.

---

## ⚙️ Features

- **Infrastructure as Code (IaC):** Fully automated provisioning with Terraform.
- **High Availability:** Multi-AZ deployment ensures resilience against failures.
- **Scalability:** Auto Scaling adjusts compute resources based on demand.
- **Cost Optimization:** Spot instances and S3 lifecycle policies to minimize cost.
- **Security:** VPC subnets with NACLs, Security Groups, and IAM roles.

---

## 🛠️ Tech Stack

- **Cloud Provider:** AWS  
- **IaC Tool:** Terraform  
- **Services Used:** VPC, EC2, ALB, ASG, RDS (Optional), S3 (Optional), CloudFront (Optional), Route53 (Optional)  
- **Networking:** Multi-AZ, NAT Gateway, Security Groups  
- **Other:** IAM, CloudWatch, Lifecycle policies  

---

🚀 Deployment Steps

1- Clone this repository:

~~~
git clone https://github.com/your-username/scalable-webapp-terraform.git
cd scalable-webapp-terraform
~~~

2- Initialize Terraform:

~~~
terraform init
~~~

3- Preview the infrastructure plan:

~~~
terraform plan
~~~

4- Deploy the infrastructure:

~~~
terraform apply
~~~

5- Access the web app via the Route53 domain once the stack is deployed.