terraform {
  required_version = ">= 1.3"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.9"
    }
  }
  backend "s3" {
    bucket         = "tf-state-bucket"
    encrypt        = true
    key            = "robotics/robot-stack/stack1"
    dynamodb_table = "core_infra_tf_lock"
    profile        = "terraform-state"
    region         = "us-east-2"
  }
}
