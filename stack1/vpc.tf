module "dev_vpc" {
  count                 = (terraform.workspace == "dev") ? 1 : 0
  source                = "../modules/vpc"
  availability_zones    = var.availability_zones
  cidr_block            = var.cidr_block
  public_subnets_count  = var.public_subnets_count
  public_subnets_cidr   = var.public_subnets_cidr
  private_subnets_count = var.private_subnets_count
  private_subnets_cidr  = var.private_subnets_cidr
  nat_gateway_count     = var.nat_gateway_count
  elastic_ips           = var.elastic_ips
  stack_name            = var.stack_name
  providers = {
    aws = aws.profile1-alias
  }
}

module "staging_vpc" {
  count                 = (terraform.workspace == "staging") ? 1 : 0
  source                = "../modules/vpc"
  availability_zones    = var.availability_zones
  cidr_block            = var.cidr_block
  public_subnets_count  = var.public_subnets_count
  public_subnets_cidr   = var.public_subnets_cidr
  private_subnets_count = var.private_subnets_count
  private_subnets_cidr  = var.private_subnets_cidr
  nat_gateway_count     = var.nat_gateway_count
  elastic_ips           = var.elastic_ips
  stack_name            = var.stack_name
  providers = {
    aws = aws.profile2-alias
  }
}

module "prod_vpc" {
  count                 = (terraform.workspace == "prod") ? 1 : 0
  source                = "../modules/vpc"
  availability_zones    = var.availability_zones
  cidr_block            = var.cidr_block
  public_subnets_count  = var.public_subnets_count
  public_subnets_cidr   = var.public_subnets_cidr
  private_subnets_count = var.private_subnets_count
  private_subnets_cidr  = var.private_subnets_cidr
  nat_gateway_count     = var.nat_gateway_count
  elastic_ips           = var.elastic_ips
  stack_name            = var.stack_name
  providers = {
    aws = aws.profile2-alias
  }
}
