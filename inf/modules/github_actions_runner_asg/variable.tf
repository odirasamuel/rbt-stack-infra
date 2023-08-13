variable "instance_name" {
  type        = string
  description = "Name of the instance"
}

variable "instance_type" {
  type        = string
  description = "Type of the instance"
}

variable "ami_id" {
  type        = string
  description = "Id of the AMI to use for the instance"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the instance will be live"
}

variable "tags" {
  type        = map(string)
  description = "CIDRs to use for private subnets"
  default     = {}
}

variable "github_repo_pat_token" {
  type        = string
  description = "token for github repo"
}
variable "github_repo_url" {
  type        = string
  description = "url for github repo"
}

variable "health_check_grace_period" {
  description = "The health check grace period"
  type        = number
  default     = 600
}

variable "desired_capacity" {
  description = "The desired number of EC2 instances in the AutoScaling Group"
  type        = number

}

variable "min_size" {
  description = "The Minimum number of EC2 instances in the AutoScaling Group"
  type        = number

}

variable "max_size" {
  description = "The Maximum number of EC2 instances in the AutoScaling Group"
  type        = number

}

variable "vpc_zone_identifier" {
  description = "The AMI for the GitHub Runner backing EC2 Instance"
  type        = list(string)
}

variable "instance_template_type" {
  description = "Whether this should use the default template (value: ebs) or the one that mounts an NVME volume (value: nvme)"
  type        = string
}

variable "volume_size" {
  description = "EBS volume size"
  type        = number
}

variable "artifact_bucket_arn" {
  description = "ARN of the S3 bucket to put artifacts into"
  type        = string
}
