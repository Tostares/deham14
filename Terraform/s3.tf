/* #create S3 bucket in region us-west-2

# Define the S3 bucket
resource "aws_s3_bucket" "example_bucket" {
  bucket = "XXXXXXXXXXXbucket"
  acl    = "private"

  tags = {
    Name = "Example Bucket"
  }
}

# Define the S3 bucket object ownership
resource "aws_s3_bucket_ownership_controls" "example_bucket" {
  bucket = aws_s3_bucket.example_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Define the S3 bucket public access block
resource "aws_s3_bucket_public_access_block" "example_bucket" {
  bucket = aws_s3_bucket.example_bucket.id

  block_public_acls       = true
  block_public_policy    = true
  ignore_public_acls     = true
  restrict_public_buckets = true
}
 */
