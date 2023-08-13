resource "aws_iam_service_linked_role" "spot" {
    aws_service_name = var.aws_service_name
}

resource "aws_kms_key" "github" {
    is_enabled = true
}

output "kms-key" {
  value = aws_kms_key.github
}