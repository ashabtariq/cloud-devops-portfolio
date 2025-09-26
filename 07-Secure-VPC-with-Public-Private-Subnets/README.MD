
🔐 Secure VPC with Bastion & Private EC2 (Terraform)

📌 Project Overview
This project provisions a secure AWS environment using Terraform.
It demonstrates a best-practice VPC setup with public and private subnets, a bastion host for SSH access, and a private EC2 instance accessible only through the bastion.

✅ Ideal for cloud security labs, DevOps practice, or portfolio projects.

🏗️ Architecture
- VPC (10.0.0.0/16)
- Public Subnet (10.0.0.0/24)
- Internet Gateway
- NAT Gateway
- Bastion Host (SSH allowed only from your IP)
- Private Subnet (10.0.1.0/24)
- Private EC2 (SSH allowed only from Bastion Host)

Security Groups
- Bastion SG → SSH from your IP
- Private EC2 SG → SSH only from Bastion SG

🔒 Security Highlights
- No direct SSH access to private EC2 (must go through bastion).
- Public access restricted to your IP address only.
- Outbound traffic allowed, inbound locked down with least privilege


📂 Files

`bash`
.
├── main.tf       # Terraform code (VPC, Subnets, IGW, NAT, EC2, SGs)
├── variables.tf  # (optional) variables file if you parameterize
├── outputs.tf    # (optional) useful outputs (bastion IP, private IPs)
└── README.md     # Project documentation
`bash`