
####################
#     S3-Buckets   #
####################
# S3 Buckets for Image Pipeline
resource "aws_s3_bucket" "input_bucket" {
  bucket = var.input-bucket-name

  tags = {
    Name        = "${var.project_name}-input"
    Environment = "dev"
  }
}

# Output bucket (for processed images)
resource "aws_s3_bucket" "output_bucket" {
  bucket = var.output-bucket-name

  tags = {
    Name        = "${var.project_name}-output"
    Environment = "dev"
  }
}

# Enable Versioning
resource "aws_s3_bucket_versioning" "input_versioning" {
  bucket = aws_s3_bucket.input_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "output_versioning" {
  bucket = aws_s3_bucket.output_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Ownership Controls (instead of ACL)
resource "aws_s3_bucket_ownership_controls" "input_ownership" {
  bucket = aws_s3_bucket.input_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_ownership_controls" "output_ownership" {
  bucket = aws_s3_bucket.output_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}


# Public Access Block (security best practice)
resource "aws_s3_bucket_public_access_block" "input_block" {
  bucket                  = aws_s3_bucket.input_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_public_access_block" "output_block" {
  bucket                  = aws_s3_bucket.output_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


# ----------------------------
# Permission: Allow S3 to invoke Lambda
# ----------------------------
resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.resize.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.input_bucket.arn
}

# ----------------------------
# S3 → Lambda Notification
# ----------------------------
resource "aws_s3_bucket_notification" "input_events" {
  bucket = aws_s3_bucket.input_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.resize.arn
    events              = ["s3:ObjectCreated:*"]
    #filter_prefix       = "uploads/" # optional: only trigger for files in uploads/ folder
    #filter_suffix       = ".jpg"     # optional: only trigger for .jpg files
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}




####################
#     IAM-ROLE     #
####################
#Create an IAM role
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "Statement1",
          "Effect" : "Allow",
          "Principal" : {
            "Service" : [
              "lambda.amazonaws.com"
            ]

          },
          "Action" : "sts:AssumeRole"

        }
      ]
    }
  )
}


#CUSTOM POLICY CREATION
resource "aws_iam_role_policy" "s3-get-put-policy" {
  name = "s3-get-put-policy"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Statement1",
        "Effect" : "Allow",
        "Action" : [
          "s3:GetObject",
          "s3:PutObject"
        ],
        "Resource" : [
          "${aws_s3_bucket.input_bucket.arn}/*",
          "${aws_s3_bucket.output_bucket.arn}/*"
        ]
      }
    ]
  })
}




# IAM Policy for Lambda to log to CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_logging" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


#########################
#     Lambda Function   #
#########################

# Install Python dependencies into build dir
resource "null_resource" "trigger_lambda_build" {
  provisioner "local-exec" {
    command = <<EOT
      rm -rf ${path.module}/../lambdas/resize/build
      mkdir -p ${path.module}/../lambdas/resize/build
      cp ${path.module}/../lambdas/resize/resize.py ${path.module}/../lambdas/resize/build/
      pip install -r ${path.module}/../lambdas/resize/requirements.txt --target ${path.module}/../lambdas/resize/build
    EOT
  }
}


data "archive_file" "lambda_DeploymentPackage" {
  type = "zip"

  source_dir  = "${path.module}/../lambdas/resize/build"
  output_path = "${path.module}/../lambdas/resize/resize_package.zip"

  depends_on = [null_resource.trigger_lambda_build]
}

# LAMBDA FUNCTION
resource "aws_lambda_function" "resize" {
  function_name    = "Resize-Image"
  handler          = "resize.resize_image"
  runtime          = "python3.10"
  role             = aws_iam_role.lambda_execution_role.arn
  filename         = data.archive_file.lambda_DeploymentPackage.output_path
  source_code_hash = data.archive_file.lambda_DeploymentPackage.output_base64sha256
  memory_size      = 256
  timeout          = 30
}



#######################################
#     CloudWatch Log Groups           #
#######################################
resource "aws_cloudwatch_log_group" "resize" {
  name              = "/aws/lambda/${aws_lambda_function.resize.function_name}"
  retention_in_days = 14
}

#########################
#     Outputs           #
#########################

# Output the ARN of the created role
output "iam_role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}

output "input-bucket-arn" {
  value = aws_s3_bucket.input_bucket.arn
}


output "output-bucket-arn" {
  value = aws_s3_bucket.output_bucket.arn
}
