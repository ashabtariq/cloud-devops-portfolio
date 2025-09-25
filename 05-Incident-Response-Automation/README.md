# 🚨 Incident Response Automation on AWS

## 📌 Project Overview
This project demonstrates how to build an **automated incident response system** on AWS using **CloudWatch Alarms, EventBridge, and Lambda**.  

When unusual activity (like suspicious IAM API calls) is detected, the system automatically triggers a **Lambda function** that takes action — such as quarantining an EC2 instance or disabling IAM keys — helping to limit the blast radius of potential security incidents.  

---

## 🏗️ Architecture
1. **CloudWatch Alarms** monitor logs and metrics for anomalies.  
2. **EventBridge Rules** capture security events (e.g., unauthorized IAM activity).  
3. **AWS Lambda** functions automatically respond to incidents by:  
   - Detaching IAM access keys  
   - Isolating EC2 instances (e.g., removing from Auto Scaling groups, revoking SG rules)  
   - Sending notifications  

---

## 🛠️ Tech Stack
- **AWS CloudWatch** – Monitoring & alarms  
- **Amazon EventBridge** – Event-driven rules  
- **AWS Lambda (Python)** – Automated response logic  
- **Terraform** – Infrastructure as Code (provision alarms, rules, and functions)  

---

## ⚙️ Deployment (Terraform)
1. Clone the repository:

```bash
git clone https://github.com/ashabtariq/cloud-devops-portfolio.git
   cd cloud-devops-portfolio/05-Incident-Response-Automation


Initialize Terraform:

~~~
cd terraform
terraform init
~~~

Deploy infrastructure:
~~~
terraform apply
~~~

📝 Example Use Case

Suspicious IAM activity detected (e.g., iam:CreateAccessKey).

CloudWatch Alarm triggers EventBridge.

EventBridge invokes a Lambda function.

Lambda automatically:

Disables the IAM user’s keys

Logs action to CloudWatch

Optionally sends alert via SNS

📂 Project Structure
05-Incident-Response-Automation/
├── terraform/           # Terraform IaC for CloudWatch, EventBridge, Lambda
├── lambdas/             # Python Lambda functions
│   ├── quarantine_ec2.py
│   └── disable_keys.py
└── README.md            # Project documentation

📊 Logging & Monitoring

CloudWatch Logs capture all Lambda executions and responses.

CloudWatch Metrics monitor anomaly detection triggers.

SNS (Optional) can be added for security team alerts.

🚀 Future Enhancements

Integrate with AWS Security Hub for centralized findings.

Use Step Functions for multi-step incident workflows.

Add Slack/Teams notifications for SOC teams.

🔗 Portfolio

This is part of my Cloud DevOps Portfolio showcasing AWS security and automation projects.
👉 Check more projects here: Cloud DevOps Portfolio
