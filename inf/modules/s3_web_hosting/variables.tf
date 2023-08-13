variable "domain_name" {
  description = "Domain name for hosting"
  type        = map(map(string))
}

variable "stack_name" {
  description = "Name of Stack"
  type        = string
}
