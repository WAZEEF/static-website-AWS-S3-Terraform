provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "static_website" {
  bucket = "wazeef-static-website-bucket-for-terraform"
}

resource "aws_s3_bucket_website_configuration" "demo" {
  bucket = aws_s3_bucket.static_website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_public_access_block" "eee" {
  bucket = aws_s3_bucket.static_website.id
  block_public_acls = false
  ignore_public_acls = false
  block_public_policy = false 
  restrict_public_buckets = false  
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.static_website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
        {
            Effect = "Allow"
            Principal = "*"
            Action = "s3:GetObject"
            Resource = "${aws_s3_bucket.static_website.arn}/*"
        }
    ]
  })
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.static_website.id
  key = "index.html"
  source = "index.html"
  content_type = "text/html" 
}

resource "aws_s3_object" "error_html" {
  bucket = aws_s3_bucket.static_website.id
  key = "error.html"
  source = "error.html"
  content_type = "text/html"
}