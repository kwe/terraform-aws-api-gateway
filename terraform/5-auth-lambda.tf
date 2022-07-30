resource "aws_iam_role" "auth_lambda_exec" {
  name               = "auth-lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "auth_lambda_policy" {
  role       = aws_iam_role.auth_lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_lambda_function" "auth" {
  function_name = "auth-hello"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_hello.key

  runtime = "nodejs16.x"
  handler = "function.handler"

  source_code_hash = data.archive_file.lambda_auth.output_base64sha256

  role = aws_iam_role.auth_lambda_exec.arn
}

resource "aws_cloudwatch_log_group" "auth-hello" {
  name = "/aws/lambda/${aws_lambda_function.auth.function_name}"

  retention_in_days = 7
}

data "archive_file" "lambda_auth" {
  type = "zip"

  source_dir  = "../${path.module}/auth"
  output_path = "../${path.module}/auth.zip"
}

resource "aws_s3_object" "lambda_auth" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "auth.zip"
  source = data.archive_file.lambda_auth.output_path

  etag = filemd5(data.archive_file.lambda_auth.output_path)
}
