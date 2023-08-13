data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  bucket_name   = var.domain_name[terraform.workspace].domain
  domain_name   = var.domain_name[terraform.workspace].domain
  uploader_name = "${var.domain_name[terraform.workspace].domain}-uploader"
  thumbnail     = var.thumbnail
  stack_name    = var.stack_name
}


resource "aws_iam_user" "web_content_uploader" {
  name = local.uploader_name
  tags = {
    Name        = local.domain_name
    Environment = terraform.workspace
  }
}

#Access key for the web content uploader
resource "aws_iam_access_key" "web_content_uploader_key" {
  user = aws_iam_user.web_content_uploader.name
}

#IAM policy for the uploader
resource "aws_iam_user_policy" "web_content_uploader_policy" {
  name = "${local.stack_name}WebContentsUploaderPolicy"
  user = aws_iam_user.web_content_uploader.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:GetBucketlocation"
        ],
        Resource = [
          "${var.website_bucket_arn}",
          "${var.website_bucket_arn}/*"
        ]
      },
    ]
  })
}

#OIDC
resource "aws_iam_openid_connect_provider" "oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["${local.thumbnail}"]
}

#Role for OIDC provioder
resource "aws_iam_role" "oidc_role" {
  name        = "githubuser_role-${local.stack_name}-${terraform.workspace}"
  description = "IAM role for OIDC"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity",
        Effect = "Allow",
        Principal = {
          Federated = [
            "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com",
          ]
        }
        Condition = {
          StringLike = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com",
            "token.actions.githubusercontent.com:sub" = "repo:Opentrons/opentrons-python-packages:*"
          }
        }
      }
    ]
  })
}

#permission to access s3 resources
resource "aws_iam_role_policy" "oidc_role_policy" {
  name = "${local.stack_name}-githubuser_role_policy"
  role = aws_iam_role.oidc_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject",
          "s3:GetBucketlocation"
        ],
        Resource = [
          "${var.website_bucket_arn}",
          "${var.website_bucket_arn}/*"
        ]
      },
    ]
  })
}