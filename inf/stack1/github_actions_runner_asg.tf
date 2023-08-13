module "openembedded_runner_asg_dev" {
  count                     = (terraform.workspace == "dev") ? 1 : 0
  source                    = "../modules/github_actions_runner_asg"
  instance_name             = "gh_actions_asg_ot3_ci_${terraform.workspace}_openembedded"
  instance_type             = var.runner_instance_type.openembedded
  ami_id                    = var.runner_ami.openembedded
  vpc_id                    = element(module.dev_vpc, 0).vpc_id
  github_repo_url           = var.runner_repo_url.openembedded
  health_check_grace_period = var.runner_health_check_grace_period.openembedded
  desired_capacity          = var.runner_pool_desired_capacity.openembedded
  min_size                  = var.runner_pool_min_size.openembedded
  max_size                  = var.runner_pool_max_size.openembedded
  vpc_zone_identifier       = element(module.dev_vpc, 0).private_subnets_id
  github_repo_pat_token     = var.runner_pool_github_token_openembedded
  instance_template_type    = var.runner_template_type.openembedded
  volume_size               = var.runner_cache_volume_size.openembedded
  artifact_bucket_arn       = element(module.dev_s3_web_hosting, 0).website_bucket_arn
  providers = {
    aws = aws.profile1-alias
  }
}

module "openembedded_runner_asg_staging" {
  count                     = (terraform.workspace == "staging") ? 1 : 0
  source                    = "../modules/github_actions_runner_asg"
  instance_name             = "gh_actions_asg_ot3_ci_${terraform.workspace}_openembedded"
  instance_type             = var.runner_instance_type.openembedded
  ami_id                    = var.runner_ami.openembedded
  vpc_id                    = element(module.staging_vpc, 0).vpc_id
  github_repo_url           = var.runner_repo_url.openembedded
  health_check_grace_period = var.runner_health_check_grace_period.openembedded
  desired_capacity          = var.runner_pool_desired_capacity.openembedded
  min_size                  = var.runner_pool_min_size.openembedded
  max_size                  = var.runner_pool_max_size.openembedded
  vpc_zone_identifier       = element(module.staging_vpc, 0).private_subnets_id
  github_repo_pat_token     = var.runner_pool_github_token_openembedded
  instance_template_type    = var.runner_template_type.openembedded
  volume_size               = var.runner_cache_volume_size.openembedded
  artifact_bucket_arn       = element(module.staging_s3_web_hosting, 0).website_bucket_arn
  providers = {
    aws = aws.profile2-alias
  }
}

module "openembedded_runner_asg_prod" {
  count                     = (terraform.workspace == "prod") ? 1 : 0
  source                    = "../modules/github_actions_runner_asg"
  instance_name             = "gh_actions_asg_ot3_ci_${terraform.workspace}_openembedded"
  instance_type             = var.runner_instance_type.openembedded
  vpc_id                    = element(module.prod_vpc, 0).vpc_id
  ami_id                    = var.runner_ami.openembedded
  github_repo_url           = var.runner_repo_url.openembedded
  health_check_grace_period = var.runner_health_check_grace_period.openembedded
  desired_capacity          = var.runner_pool_desired_capacity.openembedded
  min_size                  = var.runner_pool_min_size.openembedded
  max_size                  = var.runner_pool_max_size.openembedded
  vpc_zone_identifier       = element(module.prod_vpc, 0).private_subnets_id
  github_repo_pat_token     = var.runner_pool_github_token_openembedded
  instance_template_type    = var.runner_template_type.openembedded
  volume_size               = var.runner_cache_volume_size.openembedded
  artifact_bucket_arn       = element(module.prod_s3_web_hosting, 0).website_bucket_arn
  providers = {
    aws = aws.profile2-alias
  }
}

module "monorepo_linux_runner_asg_dev" {
  count                     = (terraform.workspace == "dev") ? 1 : 0
  source                    = "../modules/github_actions_runner_asg"
  instance_name             = "gh_actions_asg_ot3_ci_${terraform.workspace}_monorepo"
  instance_type             = var.runner_instance_type.monorepo
  vpc_id                    = element(module.dev_vpc, 0).vpc_id
  ami_id                    = var.runner_ami.monorepo
  github_repo_url           = var.runner_repo_url.monorepo
  health_check_grace_period = var.runner_health_check_grace_period.monorepo
  desired_capacity          = var.runner_pool_desired_capacity.monorepo
  min_size                  = var.runner_pool_min_size.monorepo
  max_size                  = var.runner_pool_max_size.monorepo
  vpc_zone_identifier       = element(module.dev_vpc, 0).private_subnets_id
  github_repo_pat_token     = var.runner_pool_github_token_monorepo
  instance_template_type    = var.runner_template_type.monorepo
  volume_size               = var.runner_cache_volume_size.monorepo
  artifact_bucket_arn       = element(module.dev_s3_web_hosting, 0).website_bucket_arn
  providers = {
    aws = aws.profile1-alias
  }
}

module "monorepo_linux_runner_asg_staging" {
  count                     = (terraform.workspace == "staging") ? 1 : 0
  source                    = "../modules/github_actions_runner_asg"
  instance_name             = "gh_actions_asg_ot3_ci_${terraform.workspace}_monorepo"
  instance_type             = var.runner_instance_type.monorepo
  vpc_id                    = element(module.staging_vpc, 0).vpc_id
  ami_id                    = var.runner_ami.monorepo
  github_repo_url           = var.runner_repo_url.monorepo
  health_check_grace_period = var.runner_health_check_grace_period.monorepo
  desired_capacity          = var.runner_pool_desired_capacity.monorepo
  min_size                  = var.runner_pool_min_size.monorepo
  max_size                  = var.runner_pool_max_size.monorepo
  vpc_zone_identifier       = element(module.staging_vpc, 0).private_subnets_id
  github_repo_pat_token     = var.runner_pool_github_token_monorepo
  instance_template_type    = var.runner_template_type.monorepo
  volume_size               = var.runner_cache_volume_size.monorepo
  artifact_bucket_arn       = element(module.staging_s3_web_hosting, 0).website_bucket_arn
  providers = {
    aws = aws.profile2-alias
  }
}


module "monorepo_linux_runner_asg_prod" {
  count                     = (terraform.workspace == "prod") ? 1 : 0
  source                    = "../modules/github_actions_runner_asg"
  instance_name             = "gh_actions_asg_ot3_ci_${terraform.workspace}_monorepo"
  instance_type             = var.runner_instance_type.monorepo
  vpc_id                    = element(module.prod_vpc, 0).vpc_id
  ami_id                    = var.runner_ami.monorepo
  github_repo_url           = var.runner_repo_url.monorepo
  health_check_grace_period = var.runner_health_check_grace_period.monorepo
  desired_capacity          = var.runner_pool_desired_capacity.monorepo
  min_size                  = var.runner_pool_min_size.monorepo
  max_size                  = var.runner_pool_max_size.monorepo
  vpc_zone_identifier       = element(module.prod_vpc, 0).private_subnets_id
  github_repo_pat_token     = var.runner_pool_github_token_monorepo
  instance_template_type    = var.runner_template_type.monorepo
  volume_size               = var.runner_cache_volume_size.monorepo
  artifact_bucket_arn       = element(module.prod_s3_web_hosting, 0).website_bucket_arn
  providers = {
    aws = aws.profile2-alias
  }
}


#Github actions runners scale DEV

module "secrets-dev" {
  source        = "../modules/secret-manager"
  secret_name   = var.key-value-base64.dev
  client-secret = var.client-secret-value.dev

  providers = {
    aws = aws.profile1-alias
  }

}

module "policies-dev" {
  source           = "../modules/policies"
  aws_service_name = var.aws_service_name
  providers = {
    aws = aws.profile1-alias
  }
}


module "github-runner-dev" {
  source  = "philips-labs/github-runner/aws"
  version = "v1.18.0"
  count   = (terraform.workspace == "dev") ? 1 : 0

  aws_region  = var.region
  vpc_id      = element(module.dev_vpc, 0).vpc_id
  subnet_ids  = element(module.dev_vpc, 0).private_subnets_id
  prefix      = var.runners-tag-prefix.dev
  kms_key_arn = module.policies-dev.kms-key.arn

  github_app = {
    key_base64     = module.secrets-dev.secret_id
    id             = var.app_id.dev
    client_id      = var.client_id.dev
    client_secret  = [module.secrets-dev.client-secret-value]
    webhook_secret = module.secrets-dev.client-secret-value
  }

  webhook_lambda_zip                = var.webhook_lambda_zip_file
  runner_binaries_syncer_lambda_zip = var.runner_binaries_syncer_lambda_zip_file
  runners_lambda_zip                = var.runners_lambda_zip_file
  enable_organization_runners       = true
  delay_webhook_event               = var.delay_webhook_event_sec
  instance_types                    = [var.runner_instance_type.monorepo]
  providers = {
    aws = aws.profile1-alias
  }
}


#Github actions runners scale PROD

module "policies-prod" {
  source           = "../modules/policies"
  aws_service_name = var.aws_service_name
  providers = {
    aws = aws.profile2-alias
  }
}

module "secrets-prod" {
  source        = "../modules/secret-manager"
  secret_name   = var.key-value-base64.prod
  client-secret = var.client-secret-value.prod
  providers = {
    aws = aws.profile2-alias
  }

}

module "github-runner-prod" {
  source      = "philips-labs/github-runner/aws"
  count       = (terraform.workspace == "prod") ? 1 : 0
  version     = "v1.18.0"
  aws_region  = var.region
  vpc_id      = element(module.prod_vpc, 0).vpc_id
  subnet_ids  = element(module.prod_vpc, 0).private_subnets_id
  prefix      = var.runners-tag-prefix.prod
  kms_key_arn = module.policies-prod.kms-key.arn

  github_app = {
    key_base64     = module.secrets-prod.secret_id
    id             = var.app_id.prod
    client_id      = var.client_id.prod
    client_secret  = [module.secrets-prod.client-secret-value]
    webhook_secret = module.secrets-prod.client-secret-value
  }

  webhook_lambda_zip                = var.webhook_lambda_zip_file
  runner_binaries_syncer_lambda_zip = var.runner_binaries_syncer_lambda_zip_file
  runners_lambda_zip                = var.runners_lambda_zip_file
  enable_organization_runners       = true
  delay_webhook_event               = var.delay_webhook_event_sec
  instance_types                    = [var.runner_instance_type.monorepo]
  providers = {
    aws = aws.profile2-alias
  }
}

#Github actions runners for scale
#Download github lambdas

module "lambdas" {
  source = "../modules/download-lambda"
  lambdas = [
    {
      name = "webhook"
      tag  = var.github_lambda_versions
    },
    {
      name = "runners"
      tag  = var.github_lambda_versions
    },
    {
      name = "runner-binaries-syncer"
      tag  = var.github_lambda_versions
    }
  ]
}
