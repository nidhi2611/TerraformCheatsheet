

//create s3 bucket
resource "aws_s3_bucket" "myFirstBucket"{
bucket = "websiteBucket"
  tags = {
    Name = "myFirstS3Bucket"
  }
}

//change ownership of bucket - to the one who owns the bucket should have all access
resource "aws_s3_bucket_ownership_controls" "myFirstBucket_ownership" {
  bucket = aws_s3_bucket.myFirstBucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}
//to make the bucket public for website hosting
resource "aws_s3_bucket_public_access_block" "myFirstBucket_publicAccess" {
  bucket = aws_s3_bucket.myFirstBucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

//to make the ACL (access control list) of the bucket public 
resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.myFirstBucket_ownership,
    aws_s3_bucket_public_access_block.myFirstBucket_publicAccess,
  ]

  bucket = aws_s3_bucket.myFirstBucket.id
  acl    = "public-read"
}

// adding the index.html file to S3 bucket
resource "aws_s3_object" "website"{
    bucket = aws_s3_bucket.myFirstBucket.id
    key = "index.html"
    source = "index.html"
    acl = "public-read"
}

// to change the configuration of s3 bucket to host a website url
resource "aws_s3_bucket_website_configuration" "websiteConfiguration" {
  bucket = aws_s3_bucket.myFirstBucket.id
  index_document {
    suffix = "index.html"
  }
  depends_on = [aws_s3_bucket_acl.example]
}
