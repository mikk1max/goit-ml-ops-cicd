provider "aws" {
  region = var.aws_region
}

# --- 1. IAM Роль для Lambda ---
resource "aws_iam_role" "lambda_role" {
  name = "mlops_lambda_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# --- 2. Lambda Функції ---
resource "aws_lambda_function" "validate_func" {
  filename      = "lambda/validate.zip"
  function_name = "MLOps-ValidateData"
  role          = aws_iam_role.lambda_role.arn
  handler       = "validate.lambda_handler"
  runtime       = "python3.10"
}

resource "aws_lambda_function" "log_metrics_func" {
  filename      = "lambda/log_metrics.zip"
  function_name = "MLOps-LogMetrics"
  role          = aws_iam_role.lambda_role.arn
  handler       = "log_metrics.lambda_handler"
  runtime       = "python3.10"
}

# --- 3. IAM Роль для Step Function ---
resource "aws_iam_role" "sfn_role" {
  name = "mlops_sfn_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "states.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "sfn_policy" {
  name = "mlops_sfn_invoke_policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "lambda:InvokeFunction"
      Effect = "Allow"
      Resource = [
        aws_lambda_function.validate_func.arn,
        aws_lambda_function.log_metrics_func.arn
      ]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "sfn_policy_attach" {
  role       = aws_iam_role.sfn_role.name
  policy_arn = aws_iam_policy.sfn_policy.arn
}

# --- 4. Step Function ---
resource "aws_sfn_state_machine" "mlops_pipeline" {
  name     = "MLOps-Training-Pipeline"
  role_arn = aws_iam_role.sfn_role.arn

  definition = jsonencode({
    Comment = "Automated ML Training Pipeline"
    StartAt = "ValidateData"
    States = {
      ValidateData = {
        Type     = "Task"
        Resource = aws_lambda_function.validate_func.arn
        Next     = "LogMetrics"
      }
      LogMetrics = {
        Type     = "Task"
        Resource = aws_lambda_function.log_metrics_func.arn
        End      = true
      }
    }
  })
}

# --- 5. Output ---
output "step_function_arn" {
  value       = aws_sfn_state_machine.mlops_pipeline.arn
  description = "ARN of the deployed Step Function"
}