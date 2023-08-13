module "dev_uploader" {
  count              = (terraform.workspace == "dev") ? 1 : 0
  source             = "../modules/uploader"
  domain_name        = var.domain_name
  thumbnail          = var.thumbnail
  stack_name         = var.stack_name
  website_bucket_arn = module.dev_s3_web_hosting[0].website_bucket_arn
  providers = {
    aws = aws.profile1-alias
  }

  depends_on = [
    module.dev_s3_web_hosting
  ]
}

module "staging_uploader" {
  count              = (terraform.workspace == "staging") ? 1 : 0
  source             = "../modules/uploader"
  domain_name        = var.domain_name
  thumbnail          = var.thumbnail
  stack_name         = var.stack_name
  website_bucket_arn = module.staging_s3_web_hosting[0].website_bucket_arn
  providers = {
    aws = aws.profile2-alias
  }

  depends_on = [
    module.staging_s3_web_hosting
  ]
}

module "prod_uploader" {
  count              = (terraform.workspace == "prod") ? 1 : 0
  source             = "../modules/uploader"
  domain_name        = var.domain_name
  thumbnail          = var.thumbnail
  stack_name         = var.stack_name
  website_bucket_arn = module.prod_s3_web_hosting[0].website_bucket_arn
  providers = {
    aws = aws.profile2-alias
  }

  depends_on = [
    module.prod_s3_web_hosting
  ]
}
