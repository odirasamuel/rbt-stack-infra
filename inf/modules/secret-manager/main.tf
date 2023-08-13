data "aws_secretsmanager_secret" "by-name" {
  name = var.secret_name
}

data "aws_secretsmanager_secret_version" "by-name" {
  secret_id = data.aws_secretsmanager_secret.by-name.id
}


data "aws_secretsmanager_secret" "client_secret" {
    name = var.client-secret
  }

data "aws_secretsmanager_secret_version" "client_secret" {
    secret_id = data.aws_secretsmanager_secret.client_secret.id
}


output "secret_id" {
  value = data.aws_secretsmanager_secret_version.by-name.secret_string
}

output "client-secret-value" {
    value = data.aws_secretsmanager_secret_version.client_secret.secret_string
}