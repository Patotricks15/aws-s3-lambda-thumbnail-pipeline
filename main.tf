locals {
  source_bucket_name      = "floci-s3-thumbnail-source"
  destination_bucket_name = "floci-s3-thumbnail-destination"
  thumbnail_prefix        = "thumbnails/"
  lambda_build_dir        = "${path.module}/.build/lambda"
}

resource "null_resource" "lambda_package" {
  triggers = {
    handler_sha      = filesha256("${path.module}/src/lambda/handler.py")
    requirements_sha = filesha256("${path.module}/src/lambda/requirements.txt")
    build_script_sha = filesha256("${path.module}/scripts/build_lambda_package.sh")
  }

  provisioner "local-exec" {
    command = "bash ${path.module}/scripts/build_lambda_package.sh ${path.module}"
  }
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = local.lambda_build_dir
  output_path = "${path.module}/.build/lambda.zip"

  depends_on = [null_resource.lambda_package]
}

resource "aws_s3_bucket" "source" {
  bucket = local.source_bucket_name
}

resource "aws_s3_bucket" "destination" {
  bucket = local.destination_bucket_name
}

resource "aws_iam_role" "lambda_exec" {
  name = "floci-s3-thumbnail-exec"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy" "lambda_s3_access" {
  name = "floci-s3-thumbnail-s3-access"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ]
        Resource = [
          "${aws_s3_bucket.source.arn}/*",
          "${aws_s3_bucket.destination.arn}/*"
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.source.arn,
          aws_s3_bucket.destination.arn
        ]
      }
    ]
  })
}

resource "aws_lambda_function" "thumbnail" {
  function_name = "floci-s3-thumbnail-demo"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "handler.lambda_handler"
  runtime       = "python3.12"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 30
  memory_size      = 256

  environment {
    variables = {
      DESTINATION_BUCKET = aws_s3_bucket.destination.bucket
      SOURCE_BUCKET      = aws_s3_bucket.source.bucket
      THUMBNAIL_PREFIX   = local.thumbnail_prefix
    }
  }

  depends_on = [aws_iam_role_policy_attachment.lambda_basic, aws_iam_role_policy.lambda_s3_access]
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.thumbnail.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source.arn
}

resource "aws_s3_bucket_notification" "source" {
  bucket = aws_s3_bucket.source.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.thumbnail.arn
    events              = ["s3:ObjectCreated:Put"]
    filter_suffix       = ".jpg"
  }

  lambda_function {
    lambda_function_arn = aws_lambda_function.thumbnail.arn
    events              = ["s3:ObjectCreated:Put"]
    filter_suffix       = ".jpeg"
  }

  lambda_function {
    lambda_function_arn = aws_lambda_function.thumbnail.arn
    events              = ["s3:ObjectCreated:Put"]
    filter_suffix       = ".png"
  }

  lambda_function {
    lambda_function_arn = aws_lambda_function.thumbnail.arn
    events              = ["s3:ObjectCreated:Put"]
    filter_suffix       = ".webp"
  }

  depends_on = [aws_lambda_permission.allow_s3]
}
