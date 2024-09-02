resource "aws_s3_bucket" "access_logs" {
  bucket = "jmath-access-logs-${var.env}"
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.access_logs.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${var.account_number}:root"
        },
        "Action" : "s3:*",
        "Resource" : "${aws_s3_bucket.access_logs.arn}/*"
      }
    ]
  })
}

