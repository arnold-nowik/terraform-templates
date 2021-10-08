resource "aws_s3_bucket" "example-stg-s3-bucket" {
  bucket_prefix = "example-staging-"
  acl           = "private"

  versioning {
    enabled = true
  }
}
