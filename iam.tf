data "aws_iam_policy_document" "sample-s3" {
  statement {
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.sample.bucket}"
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObject",
      "s3:GetObjectAcl",
      "s3:DeleteObject"
    ]
    resources = [
      "arn:aws:s3:::${aws_s3_bucket.sample.bucket}/*"
    ]
  }
}

resource "aws_iam_policy" "sample-s3" {
  name   = "s3-sample-terraform"
  policy = data.aws_iam_policy_document.sample-s3.json
}

resource "aws_iam_role" "sample-ec2-s3" {
  name = "sample-ec2-to-s3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sample" {
  policy_arn = aws_iam_policy.sample-s3.arn
  role       = aws_iam_role.sample-ec2-s3.name
}