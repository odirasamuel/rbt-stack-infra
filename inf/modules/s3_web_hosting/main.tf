data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  bucket_name          = var.domain_name[terraform.workspace].domain
  domain_name          = var.domain_name[terraform.workspace].domain
  uploader_name        = "${var.domain_name[terraform.workspace].domain}-uploader"
  redirect_bucket_name = "www.${var.domain_name[terraform.workspace].domain}"
  stack_name           = var.stack_name
}


#Redirect Bucket
resource "aws_s3_bucket" "website_redirect_bucket" {
  bucket = local.redirect_bucket_name

  tags = {
    Name        = local.redirect_bucket_name
    Environment = terraform.workspace
  }
}

#Redirect bucket website configuration
resource "aws_s3_bucket_website_configuration" "website_redirect_bucket" {
  bucket = aws_s3_bucket.website_redirect_bucket.id

  redirect_all_requests_to {
    host_name = local.bucket_name
    protocol  = "https"
  }
}

#Redirect website bucket ACL
resource "aws_s3_bucket_acl" "website_redirect_bucket_acl" {
  bucket = aws_s3_bucket.website_redirect_bucket.id
  acl    = "public-read"
}


#Redirect website bucket policy
resource "aws_s3_bucket_policy" "access_to_website-redirect_bucket" {
  bucket = aws_s3_bucket.website_redirect_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject",
        ],
        Resource = [
          "${aws_s3_bucket.website_redirect_bucket.arn}",
          "${aws_s3_bucket.website_redirect_bucket.arn}/*"
        ]
      },
    ]
  })
}


#S3 Bucket
resource "aws_s3_bucket" "website_bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = terraform.workspace
  }
}

#Website bucket cors configuration
resource "aws_s3_bucket_cors_configuration" "website_bucket_cors" {
  bucket = aws_s3_bucket.website_bucket.id

  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://${local.redirect_bucket_name}"]
    max_age_seconds = 30000
  }
}

#Website bucket versioning
resource "aws_s3_bucket_versioning" "website_bucket_versioning" {
  bucket = aws_s3_bucket.website_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

#Website-bucket website configuration
resource "aws_s3_bucket_website_configuration" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "/404.html"
  }
}

resource "aws_s3_bucket_acl" "website_bucket_acl" {
  bucket = aws_s3_bucket.website_bucket.id
  acl    = "public-read"
}



#Website bucket policy
resource "aws_s3_bucket_policy" "access_to_website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action = [
          "s3:GetObject",
        ],
        Resource = [
          "${aws_s3_bucket.website_bucket.arn}",
          "${aws_s3_bucket.website_bucket.arn}/*"
        ]
      },
    ]
  })
}


#Website certificate
resource "aws_acm_certificate" "website_cert" {
  domain_name               = local.domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${local.domain_name}", local.redirect_bucket_name]
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = local.domain_name
    Environment = terraform.workspace
  }

}

#Hosted zone for domain
resource "aws_route53_zone" "domain" {
  name = local.domain_name
}

#Record validation for domain
resource "aws_route53_record" "domain_validation" {
  for_each = {
    for dvo in aws_acm_certificate.website_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.domain.zone_id
}

#Validate certificate for domain
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.website_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.domain_validation : record.fqdn]
}


#CloudFront function to update URIs path
resource "aws_cloudfront_function" "index_rewriter" {
  name    = "${local.stack_name}-index_rewriter-${terraform.workspace}"
  runtime = "cloudfront-js-1.0"
  comment = "add index.html to path URIs"
  publish = true
  code    = file("${path.module}/functions/cloudfront/index-append/index.js")
}


#Cloudfront distribution for redirect website
resource "aws_cloudfront_distribution" "website_redirect_distribution" {
  origin {
    domain_name = aws_s3_bucket.website_redirect_bucket.bucket_regional_domain_name
    origin_id   = local.domain_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  enabled             = true
  default_root_object = "index.html"
  aliases             = ["${local.redirect_bucket_name}"]
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/404.html"
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.domain_name
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 8640
    max_ttl                = 31536000
    compress               = true
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method  = "sni-only"
  }

  tags = {
    Name        = local.redirect_bucket_name
    Environment = terraform.workspace
  }

  depends_on = [
    aws_s3_bucket.website_redirect_bucket
  ]
}


#Cloudfront distribution for website hosting
resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_id   = local.domain_name
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
  }
  enabled             = true
  default_root_object = "index.html"
  aliases             = ["${local.domain_name}"]
  custom_error_response {
    error_caching_min_ttl = 0
    error_code            = 404
    response_code         = 200
    response_page_path    = "/404.html"
  }
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.domain_name
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
      headers = ["Origin"]
    }
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 8640
    max_ttl                = 31536000
    compress               = true

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.index_rewriter.arn
    }

  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert_validation.certificate_arn
    ssl_support_method  = "sni-only"
  }

  tags = {
    Name        = local.domain_name
    Environment = terraform.workspace
  }
}

#A-record for domain
resource "aws_route53_record" "domain_a_record" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = local.domain_name
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.website_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.website_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

#A-record for redirecting domain
resource "aws_route53_record" "domain_a_redirect_record" {
  zone_id = aws_route53_zone.domain.zone_id
  name    = local.redirect_bucket_name
  type    = "A"
  alias {
    name                   = aws_cloudfront_distribution.website_redirect_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.website_redirect_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}



output "website_bucket_arn" {
  value = aws_s3_bucket.website_bucket.arn
}
