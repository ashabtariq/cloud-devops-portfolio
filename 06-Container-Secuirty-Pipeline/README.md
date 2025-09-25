# 🛡️ Secure Container Deployment Pipeline on AWS

This project demonstrates how to build a **secure CI/CD pipeline** for containerized applications (Node.js, Python, or Go) with a strong focus on **container security and least-privilege access**.  

The pipeline runs on **GitHub Actions**, scans container images for vulnerabilities before pushing them to **Amazon Elastic Container Registry (ECR)**, and enforces **secure IAM task roles** for deployment to **ECS (Fargate)**.

---

## 🚀 Project Goals
- Automate the **build → scan → push → deploy** lifecycle of containerized applications.
- Integrate **container security scanning** (Trivy/Grype) into the pipeline to detect vulnerabilities before production.
- Ensure **principle of least privilege** by using ECS task roles and tightly scoped IAM policies.
- Deploy applications securely on **AWS ECS Fargate**.

---

## ⚙️ Pipeline Flow
1. **Checkout & Build**
   - GitHub Actions builds the containerized application.
2. **Security Scanning**
   - Run **Trivy/Grype** to detect OS and library vulnerabilities.
   - Fail pipeline on **HIGH** or **CRITICAL** findings.
3. **Push to ECR**
   - Securely authenticate and push the image to **Amazon ECR**.
4. **Deploy to ECS**
   - Application deployed via **ECS Fargate** with **task roles** that limit permissions.

---

## 🔐 Security Features
- **Vulnerability Scanning**  
  Pre-deployment image scans with **Trivy/Grype**.  

- **IAM Least Privilege**  
  ECS task roles scoped only to required services (e.g., S3 read-only, DynamoDB read/write).  

- **ECR Security**  
  Images stored in a private registry with lifecycle policies to remove outdated versions.  

- **Fail-Fast Pipeline**  
  Pipeline blocks deployments on severe vulnerabilities.  

---

## 📂 Tech Stack
- **Languages**: Node.js / Python / Go  
- **AWS Services**: ECS (Fargate), ECR, IAM, CloudWatch  
- **CI/CD**: GitHub Actions  
- **Security**: Trivy, Grype  

---

## 📸 Pipeline Overview
```mermaid
flowchart TD
    A[GitHub Push] --> B[Build Docker Image]
    B --> C[Scan with Trivy/Grype]
    C -->|Pass| D[Push to Amazon ECR]
    C -->|Fail| E[Stop Pipeline 🚨]
    D --> F[Deploy to ECS Fargate]
    F --> G[ECS Task Role (Least Privilege)]
