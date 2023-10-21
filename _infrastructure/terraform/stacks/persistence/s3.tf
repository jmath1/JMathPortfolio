resource "aws_s3_bucket" "static_files" {
  bucket = "jmath-static-files-${var.env}"
}

resource "aws_s3_bucket_public_access_block" "public_policy" {
  bucket = aws_s3_bucket.static_files.bucket

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.static_files.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.static_files.arn}/*"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::471528030347:root"
        },
        "Action" : "s3:*",
        "Resource" : "${aws_s3_bucket.static_files.arn}/*"
      }
    ]
  })
}