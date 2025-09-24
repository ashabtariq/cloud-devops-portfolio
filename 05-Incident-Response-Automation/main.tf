# ─────────────────────────────
# Get AWS account details
# ─────────────────────────────
data "aws_caller_identity" "current" {}

# ─────────────────────────────
# S3 bucket for CloudTrail logs
# ─────────────────────────────
resource "aws_s3_bucket" "cloudtrail_logs" {
  bucket        = "cloudtrail-logs-${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  tags = {
    Name        = "cloudtrail-logs"
    Environment = "dev"
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "cloudtrail_logs" {
  bucket                  = aws_s3_bucket.cloudtrail_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ─────────────────────────────
# CloudTrail bucket policy
# ─────────────────────────────
resource "aws_s3_bucket_policy" "cloudtrail_policy" {
  bucket = aws_s3_bucket.cloudtrail_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AWSCloudTrailAclCheck"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:GetBucketAcl"
        Resource = aws_s3_bucket.cloudtrail_logs.arn
      },
      {
        Sid    = "AWSCloudTrailWrite"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.cloudtrail_logs.arn}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

# ─────────────────────────────
# CloudWatch Logs group
# ─────────────────────────────
resource "aws_cloudwatch_log_group" "cloudtrail" {
  name              = "/aws/cloudtrail/logs"
  retention_in_days = 14
}

resource "aws_iam_role" "cloudtrail_cw_role" {
  name = "CloudTrailCloudWatchRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "cloudtrail_cw_policy" {
  name = "CloudTrailCloudWatchPolicy"
  role = aws_iam_role.cloudtrail_cw_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
      }
    ]
  })
}


# ───────────────────────────────────────────
# CloudWatch  Filter (CreateAccessKey)
# ───────────────────────────────────────────

resource "aws_cloudwatch_log_metric_filter" "iam_accesskey_created" {
  name           = "IAMAccessKeyCreated"
  log_group_name = aws_cloudwatch_log_group.cloudtrail.name
  pattern        = "{ ($.eventName = CreateAccessKey) }"

  metric_transformation {
    name      = "IAMAccessKeyCreatedCount"
    namespace = "Security"
    value     = "1"
  }
}


# ───────────────────────────────────────────
# CloudWatch Alarms
# ───────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "iam_accesskey_alarm" {
  alarm_name          = "IAMAccessKeyCreatedAlarm"
  metric_name         = aws_cloudwatch_log_metric_filter.iam_accesskey_created.metric_transformation[0].name
  namespace           = "Security"
  statistic           = "Sum"
  period              = 60
  evaluation_periods  = 1
  threshold           = 0
  comparison_operator = "GreaterThanThreshold"

  #alarm_description = "Send to SNS Topic if threshold > 0"
  #alarm_actions     = [aws_sns_topic.alarm_topic.arn]

  #alarm_actions = [aws_lambda_function.IAM-Responder.function_name]
}


# # ───────────────────────────────────────────
# # EventBridge Integration
# # ───────────────────────────────────────────
resource "aws_cloudwatch_event_rule" "iam_create_accesskey_rule" {
  name          = "IAMCreateAccessKeyRule"
  description   = "Capture IAM CreateAccessKey API calls"
  event_pattern = <<EOF
{
  "source": ["aws.iam"],
  "detail-type": ["AWS API Call via CloudTrail"],
  "detail": {
    "eventSource": ["iam.amazonaws.com"],
    "eventName": ["CreateAccessKey"]
  }
}
EOF
}

# EventBridge → Lambda target
resource "aws_cloudwatch_event_target" "iam_create_accesskey_target" {
  rule      = aws_cloudwatch_event_rule.iam_create_accesskey_rule.name
  target_id = "IAMResponderLambda"
  arn       = aws_lambda_function.IAM-Responder.arn
}

# Allow EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.IAM-Responder.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.iam_create_accesskey_rule.arn
}



# ─────────────────────────────
# CloudTrail Trail
# ─────────────────────────────
resource "aws_cloudtrail" "main" {
  name                          = "IAM-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true

  cloud_watch_logs_group_arn = "${aws_cloudwatch_log_group.cloudtrail.arn}:*"
  cloud_watch_logs_role_arn  = aws_iam_role.cloudtrail_cw_role.arn
}


# ─────────────────────────────
# Lambda Functions
# ─────────────────────────────

resource "null_resource" "ensure_build_dir" {
  provisioner "local-exec" {
    when    = create
    command = "mkdir -p ${path.module}/lambda/build"
  }
}


# Install Python dependencies into build dir
resource "null_resource" "trigger_lambda_build" {
  provisioner "local-exec" {
    command = <<EOT
      rm -rf ${path.module}/lambda/build
      mkdir -p ${path.module}/lambda/build
      cp ${path.module}/lambda/respond.py ${path.module}/lambda/build/
      pip install -r ${path.module}/lambda/requirements.txt --target ${path.module}/lambda/build
    EOT
  }
}


data "archive_file" "lambda_DeploymentPackage" {
  type        = "zip"
  source_dir  = "${path.module}/lambda/build"
  output_path = "${path.module}/lambda/lambda.zip"

  depends_on = [null_resource.ensure_build_dir]
}


# LAMBDA FUNCTION
resource "aws_lambda_function" "IAM-Responder" {
  function_name    = "IAM-Responder"
  handler          = "respond.handler"
  runtime          = "python3.10"
  role             = aws_iam_role.lambda_execution_role.arn
  filename         = data.archive_file.lambda_DeploymentPackage.output_path
  source_code_hash = data.archive_file.lambda_DeploymentPackage.output_base64sha256
  memory_size      = 256
  timeout          = 30
}


# # ─────────────────────────────
# # Policies
# # ─────────────────────────────

resource "aws_iam_role" "lambda_execution_role" {
  name = "my-lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


# resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_lambda" {
#   statement_id  = "AllowExecutionFromCloudWatch"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.IAM-Responder.function_name
#   principal     = "cloudwatch.amazonaws.com"                          # Or "events.amazonaws.com" if directly from CloudWatch Events
#   source_arn    = aws_cloudwatch_metric_alarm.iam_accesskey_alarm.arn # Or CloudWatch alarm ARN if direct
# }

resource "aws_iam_role_policy" "lambda_iam_accesskey_policy" {
  name = "LambdaIAMAccessKeyPolicy"
  role = aws_iam_role.lambda_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "iam:ListAccessKeys",
          "iam:UpdateAccessKey"
        ],
        Resource = "arn:aws:iam::*:user/*"
      }
    ]
  })
}


#######################################
#     CloudWatch Log Groups           #
#######################################
resource "aws_cloudwatch_log_group" "IAM-Responder" {
  name              = "/aws/lambda/${aws_lambda_function.IAM-Responder.function_name}"
  retention_in_days = 14
}






