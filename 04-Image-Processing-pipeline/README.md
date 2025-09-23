# 📷 Serverless Image Processing Pipeline on AWS

This project demonstrates a **serverless image processing pipeline** on AWS using **S3, Lambda and Terraform**.  

When a user uploads an image to an S3 bucket, it triggers a **Lambda function** that starts a **specified Steps**. The workflow performs multiple steps:  

1. **Resize the image**  
2. **Apply watermark**  (Planned)  
3. **Store the processed image** in a destination S3 bucket  

All infrastructure is provisioned with **Terraform**, and the system is fully serverless and event-driven.

---

## 🚀 Architecture

```text
                  [User Uploads Image]
                           │
                           ▼
                       [S3 Bucket]
                     (Event Trigger)
                           │ 
                           ▼
                       [Lambda 1]
                           │
          ┌────────────────┼────────────────┐
          ▼                ▼                ▼
   [Lambda: Resize]   [Lambda: Watermark]*   [Lambda: Store]
                           │
                           ▼
                    [Destination S3 Bucket]

**Currently only resize is implemented to show proof of work but rest of the function are planned**


🛠️ AWS Services Used

Amazon S3 – Stores original and processed images
AWS Lambda – Serverless compute for image transformations
Amazon CloudWatch – Logging and monitoring
IAM – Secure access control
Terraform – Infrastructure as Code (IaC)


.
├── terraform/           # Terraform IaC for provisioning AWS resources
│   ├── lambda.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── s3.tf
├── lambdas/             # Lambda function source code
│   ├── resize/resize.py
│   ├── watermark.py (Planned)
│   └── store.py     (Planned)
└── README.md            # Project documentation



⚡ How It Works

1 - User uploads an image → Source S3 bucket
2 - S3 triggers Lambda (initializer) → starts the resize Lambda Function
3 - Lambda Functions executes sequential steps:
     3.1 - Resize Lambda → resizes image
     3.2 - Watermark Lambda → applies watermark (Planned)
     3.3 - Store Lambda → saves final image to destination S3 bucket (Planned)
4 - Processed image available in Destination S3 bucket


🏗️ Deployment (Terraform)
Prerequisites

AWS CLI configured with proper credentials
Terraform installed (>=1.5)
Python 3.9+ for Lambda functions


Steps
~~~
# Clone repo
git clone https://github.com/ashabtariq/cloud-devops-portfolio
cd 04-image-processing-pipeline/terraform

# Initialize and apply Terraform
terraform init
terraform apply -auto-approve

~~~

Terraform provisions:

2 x S3 buckets (input + output) with lambda event trigger
1 x Lambda function: Including automated dependencies installation 
IAM roles & permissions


🔍 Testing the Pipeline

Upload an image to the input S3 bucket:

~~~
aws s3 cp test.jpg s3://your-input-bucket/
~~~

Monitor workflow execution in CloudWatch Logs Group

Download processed image from output S3 bucket:

~~~
aws s3 cp s3://your-output-bucket/test-resized.jpg .
~~~


📊 Monitoring

CloudWatch Logs for each Lambda execution
CloudWatch Metrics for error rates and execution times


🚧 Future Enhancements

Add support for multiple formats (PNG, GIF, WEBP)
Integrate with Amazon Rekognition for image moderation
Notify users via SNS/Email when processing is complete
CI/CD pipeline using GitHub Actions for Terraform + Lambda updates



👨‍💻 Author

Built by Ashab Tariq

Keep checking my GitHub for new cloud projects 🚀