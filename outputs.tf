output "bucket_name" {
  value = aws_s3_bucket.source.bucket
}

output "lambda_name" {
  value = aws_lambda_function.thumbnail.function_name
}

output "destination_bucket_name" {
  value = aws_s3_bucket.destination.bucket
}
