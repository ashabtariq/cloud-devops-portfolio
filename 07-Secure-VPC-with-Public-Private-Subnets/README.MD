
🔐 Secure VPC with Bastion & Private EC2 (Terraform)

📌 Project Overview
This project provisions a secure AWS environment using Terraform.
It demonstrates a best-practice VPC setup with public and private subnets, a bastion host for SSH access, and a private EC2 instance accessible only through the bastion.

✅ Ideal for cloud security labs, DevOps practice, or portfolio projects.

🏗️ Architecture
~~~
                   ┌─────────────────────────────┐
                   │          VPC (10.0.0.0/16)  │
                   │                             │
                   │   ┌──────────────────────┐  │
                   │   │  Public Subnet       │  │
                   │   │  (10.0.0.0/24)       │  │
                   │   │                      │  │
Internet  <──────► │   │ IGW ── NAT GW        │  │
                   │   │   │                  │  │
                   │   │ Bastion Host (EC2)   │  │
                   │   │   [SSH from Your IP] │  │
                   │   └──────────────────────┘  │
                   │                             │
                   │   ┌──────────────────────┐  │
                   │   │  Private Subnet      │  │
                   │   │  (10.0.1.0/24)       │  │
                   │   │                      │  │
                   │   │ Private EC2          │  │
                   │   │ [SSH only from       │  │
                   │   │  Bastion SG]         │  │
                   │   └──────────────────────┘  │
                   │                             │
                   └─────────────────────────────┘
~~~



Security Groups
- Bastion SG → SSH from your IP
- Private EC2 SG → SSH only from Bastion SG

🔒 Security Highlights
- No direct SSH access to private EC2 (must go through bastion).
- Public access restricted to your IP address only.
- Outbound traffic allowed, inbound locked down with least privilege


📂 Files

~~~

├── main.tf       # Terraform code (VPC, Subnets, IGW, NAT, EC2, SGs)
├── variables.tf  # (optional) variables file if you parameterize
├── outputs.tf    # (optional) useful outputs (bastion IP, private IPs)
└── README.md     # Project documentation
~~~


🚀 Deployment Steps

1️⃣ Prerequisites
- Terraform installed
- AWS CLI configured (aws configure)
- Existing SSH keypair ~~~ (~/.ssh/id_rsa.pub or update path in code) ~~~

2️⃣ Initialize Terraform
~~~
terraform init
~~~

3️⃣ Plan Infrastructure
~~~
terraform plan -out tfplan
~~~

4️⃣ Apply Infrastructure
~~~
terraform apply tfplan
~~~

🔑 Accessing Instances
Bastion Host (Public Subnet)
~~~
ssh -i ~/.ssh/id_rsa ubuntu@<BASTION_PUBLIC_IP>
~~~

Private EC2 (via Bastion)
~~~
ssh -i ~/.ssh/id_rsa -J ubuntu@<BASTION_PUBLIC_IP> ubuntu@<PRIVATE_EC2_IP>
~~~


🧹 Cleanup

Destroy resources to avoid charges:
~~~
terraform destroy
~~~


🏷️ Tags

AWS Terraform Cloud Security Bastion Host VPC DevOps


✍️ Author
Ashab Tariq
Cloud & DevOps Enthusiast | AWS | Terraform | Security Labs
