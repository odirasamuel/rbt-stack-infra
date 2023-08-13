variable "cidr_block" {
  description = "CIDR block of VPC"
  type        = map(string)
}

variable "public_subnets_cidr" {
  description = "Public Subnets CIDRs"
  type        = map(list(string))
}

variable "private_subnets_cidr" {
  description = "Private Subnets CIDRs"
  type        = map(list(string))
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
}

variable "private_subnets_count" {
  description = "Number of private subnets to be created"
  type        = map(number)
}

variable "public_subnets_count" {
  description = "Number of public subnets to be created"
  type        = map(number)
}

variable "nat_gateway_count" {
  description = "Number of NAT Gateways to be created"
  type        = map(number)
}

variable "elastic_ips" {
  description = "Number of required Elastic IPs to allocate to NAT Gateways, must be equal to the number of NAT Gateways"
  type        = map(number)
}

variable "domain_name" {
  description = "Domain name for hosting"
  type        = map(map(string))
}

variable "thumbnail" {
  description = "Thumbnail for OIDC"
  type        = string
}

variable "stack_name" {
  description = "Name of Stack"
  type        = string
}

variable "runner_health_check_grace_period" {
  description = "Runner health check for each runner pool "
  type        = map(number)
}

variable "runner_repo_url" {
  description = "Github repo for each runner pool"
  type        = map(string)
}

variable "runner_ami" {
  description = "base AMI to layer packer on for each runner pool"
  type        = map(string)
}

variable "runner_instance_type" {
  description = "EC2 instance type for each runner pool"
  type        = map(string)
}

variable "runner_pool_desired_capacity" {
  description = "Desired size of each runner pool"
  type        = map(number)
}

variable "runner_pool_min_size" {
  description = "Minimum size of each runner pool"
  type        = map(number)
}

variable "runner_pool_max_size" {
  description = "Maximum size of each runner pool"
  type        = map(number)
}

variable "runner_pool_github_token_monorepo" {
  description = "PAT for runner access to monorepo. Provide per-call."
  type        = string
  sensitive   = true
}

variable "runner_pool_github_token_openembedded" {
  description = "PAT for runner access to openembedded. Provide per-call."
  type        = string
  sensitive   = true
}

variable "runner_template_type" {
  description = "Whether each runner should use nvme or ebs storage. must align with runner_instance_type. either nvme or ebs"
  type        = map(string)
}

variable "runner_cache_volume_size" {
  description = "EBS volume size"
  type        = map(number)
}

variable "region" {
  description = "region for runners"
  type        = string
}

variable "aws_service_name" {
  description = "iam service linked role"
  type        = string
}

variable "key-value-base64" {
  description = "github runner key value base64"
  type        = map(string)
}

variable "client-secret-value" {
  description = "github runner client secret value"
  type        = map(string)
}

variable "app_id" {
  description = "github app id"
  type        = map(string)
}

variable "client_id" {
  description = "github app client id"
  type        = map(string)
}

variable "runners-tag-prefix" {
  description = "github runner app prefix"
  type        = map(string)
}

variable "webhook_lambda_zip_file" {
  description = "github runner app webhook lambda"
  type        = string
}

variable "runner_binaries_syncer_lambda_zip_file" {
  description = "github runner app runner binaries syncer lambda"
  type        = string
}

variable "runners_lambda_zip_file" {
  description = "github runner app runner lambda"
  type        = string
}

variable "delay_webhook_event_sec" {
  description = "delay time for webhook event"
  type        = number
}
#github actions runners scale
variable "github_lambda_versions" {
  description = "version for the github lambdas"
  type        = string
}