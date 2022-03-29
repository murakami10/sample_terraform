
resource "aws_s3_bucket" "sample" {
  bucket = "sample-murakami10-terraform"
}

resource "aws_s3_bucket_public_access_block" "sample" {
  bucket                  = aws_s3_bucket.sample.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
