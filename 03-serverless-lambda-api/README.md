# 🚀 Serverless Application with AWS Lambda & API Gateway

## 📌 Project Overview
This project demonstrates a **serverless architecture** using **AWS Lambda**, **API Gateway**, and **DynamoDB**, provisioned entirely with **Terraform**.  

The example application is a **URL Shortener** (you can also extend it into an image processing app). The solution highlights how to build **scalable, cost-efficient workloads** without managing servers.  

📝 **Portfolio Highlight**:  
*“Developed serverless applications using AWS Lambda, API Gateway, and Terraform for scalable and cost-efficient workloads.”*

---

## ⚙️ Architecture
1. **AWS Lambda (Python/Node.js)** – core backend logic.  
2. **Amazon DynamoDB** – NoSQL database for storing short URLs.  
3. **Amazon API Gateway** – exposes REST endpoints for the application.  
4. **IAM Roles & Policies** – secure access management for Lambda & DynamoDB.  
5. **Terraform** – Infrastructure as Code for repeatable deployments.  

---

## 🏗️ Infrastructure Diagram
```mermaid
graph TD;
    Client[Client Request] --> APIGateway[API Gateway]
    APIGateway --> Lambda[AWS Lambda Function]
    Lambda --> DynamoDB[(DynamoDB Table)]


🔧 Features

--> Create and retrieve short URLs.
--> DynamoDB for fast, scalable key-value storage.
--> RESTful API endpoints secured via API Gateway.
--> Fully automated deployment using Terraform.
--> Pay-per-use model with serverless cost optimization.


🚀 Getting Started
1️⃣ Prerequisites

AWS CLI
  configured

Terraform
  installed

Python 3.x or Node.js runtime

2️⃣ Clone Repository
~~~
git clone https://github.com/your-username/serverless-url-shortener.git
cd serverless-url-shortener
~~~

3️⃣ Deploy Infrastructure
~~~
cd terraform
terraform init
terraform plan
terraform apply
~~~

4️⃣ Deploy Lambda Code

Package and upload the Lambda function:

cd lambda
zip function.zip handler.py
~~~
aws lambda update-function-code \
  --function-name urlShortenerFunction \
  --zip-file fileb://function.zip
~~~


5️⃣ Test API

Retrieve API endpoint from Terraform output.

Example request:
~~~
curl -X POST https://<api-id>.execute-api.<region>.amazonaws.com/prod/shorten \
  -d '{"url":"https://example.com"}'
~~~


🛠️ Tech Stack

--> AWS Lambda – serverless compute
--> Amazon DynamoDB – NoSQL storage
--> Amazon API Gateway – REST API management
--> Terraform – Infrastructure as Code