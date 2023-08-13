variable "domain_name" {
  description = "Domain name for hosting"
  type        = map(map(string))
}

variable "website_bucket_arn" {
  description = "Website bucket ARN"
  type        = string
}

variable "thumbnail" {
  description = "Thumbnail for OIDC"
  type        = string
}

variable "stack_name" {
  description = "Name of Stack"
  type        = string
}