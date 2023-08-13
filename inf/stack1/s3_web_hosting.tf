module "dev_s3_web_hosting" {
  count       = (terraform.workspace == "dev") ? 1 : 0
  source      = "../modules/s3_web_hosting"
  domain_name = var.domain_name
  stack_name  = var.stack_name
  providers = {
    aws = aws.profile1-alias
  }
}

module "staging_s3_web_hosting" {
  count       = (terraform.workspace == "staging") ? 1 : 0
  source      = "../modules/s3_web_hosting"
  domain_name = var.domain_name
  stack_name  = var.stack_name
  providers = {
    aws = aws.profile2-alias
  }
}

module "prod_s3_web_hosting" {
  count       = (terraform.workspace == "prod") ? 1 : 0
  source      = "../modules/s3_web_hosting"
  domain_name = var.domain_name
  stack_name  = var.stack_name
  providers = {
    aws = aws.profile1-alias
  }
}
