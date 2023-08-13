locals {
  volume_sizes = var.volume_size == 0 ? [] : [var.volume_size]
  labels       = "selfhosted,linux,x64,selfhosted-linux-x64,stage-${terraform.workspace}"
}

resource "tls_private_key" "algorithm" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.instance_name}-key"
  public_key = tls_private_key.algorithm.public_key_openssh
}

resource "aws_security_group" "default" {
  name        = var.instance_name
  description = "Default access"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    "Name" = "${var.instance_name} default Access"
  }
}


resource "aws_iam_role" "default" {
  name = "${var.instance_name}_default"
  path = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          "Service" : "ec2.amazonaws.com"
        },
        Effect = "Allow"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "default" {
  name = "${var.instance_name}-default"
  role = aws_iam_role.default.name
}

resource "aws_iam_policy" "default" {
  name        = "${var.instance_name}_default_policy"
  description = "Policy for the bastion ec2 instance"

  # permit SSM to connect to support remote ssh via aws cli
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel",
          "ssm:UpdateInstanceInformation",
          "ssm:ListAssociations",
          "ssm:ListInstanceAssociations",
          "ec2messages:GetMessages"
        ],
        Resource = "*"
      },
      {
        Action = [
          "rds:Describe*",
          "rds:List*",
          "rds:CreateDBClusterSnapshot",
          "rds:DescribeDBClusterSnapshots",
          "rds:AddTagsToResource",
          "rds-data:ExecuteStatement",
          "rds-data:BatchExecuteStatement",
          "rds-data:ExecuteSql",
          "rds-data:BeginTransaction",
          "rds-data:CommitTransaction",
          "rds-data:RollbackTransaction",
          "tag:GetResources",
          "secretsmanager:ListSecrets",
          "secretsmanager:DescribeSecret",
          "secretsmanager:CreateSecret",
          "dbqms:GetQueryString",
          "dbqms:DescribeQueryHistory",
          "dbqms:CreateQueryHistory",
          "dbqms:UpdateQueryHistory",
          "dbqms:DeleteQueryHistory",
          "dbqms:CreateFavoriteQuery",
          "dbqms:UpdateFavoriteQuery",
          "dbqms:DescribeFavoriteQueries",
          "dbqms:DeleteFavoriteQueries"
        ],
        Effect   = "Allow",
        Resource = "*"
      },
      {
        Effect   = "Allow",
        Action   = "s3:ListAllMyBuckets",
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ],
        Resource = "arn:aws:s3:::*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:PutObjectVersion",
          "s3:DeleteObject",
          "s3:DeleteObjectVersion",
          "s3:ObjectOwnerOverrideToBucketOwner",
          "s3:PutObjectAcl",
          "s3:PutObjectAcl",
          "s3:GetBucketLocation"
        ],
        Resource = [
          "${aws_s3_bucket.cache_bucket.arn}",
          "${aws_s3_bucket.cache_bucket.arn}/*",
          "${var.artifact_bucket_arn}",
          "${var.artifact_bucket_arn}/*"
        ]
      }
    ]
  })

}

resource "aws_iam_policy_attachment" "ec2_policy_attachment_bastion" {
  name       = "bastion_policy_attachment"
  roles      = [aws_iam_role.default.name]
  policy_arn = aws_iam_policy.default.arn
}


resource "aws_launch_template" "ec2_launch_template" {
  name                   = "${var.instance_name}_lt"
  description            = "Launch Template for GitHub Runners EC2 AutoScaling Group"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.generated_key.key_name
  user_data              = base64encode(templatefile("${path.module}/bootstrap_${var.instance_template_type}.tmpl", { github_repo_url = var.github_repo_url, github_repo_pat_token = var.github_repo_pat_token, cache_bucket_arn = aws_s3_bucket.cache_bucket.arn, labels = local.labels, artifact_bucket_arn = var.artifact_bucket_arn }))
  vpc_security_group_ids = [aws_security_group.default.id]
  dynamic "block_device_mappings" {
    for_each = local.volume_sizes
    content {
      device_name = "/dev/sdf"
      ebs {
        volume_size           = block_device_mappings.value
        delete_on_termination = false
        volume_type           = "gp2"
      }
    }
  }
  iam_instance_profile {
    arn = aws_iam_instance_profile.default.arn
  }
  tags = {
    Name = "github_runner"
  }
}

resource "aws_autoscaling_group" "github_runners_asg" {
  name                      = "${var.instance_name}_asg"
  health_check_type         = "EC2"
  health_check_grace_period = var.health_check_grace_period
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  vpc_zone_identifier       = var.vpc_zone_identifier
  launch_template {
    id      = aws_launch_template.ec2_launch_template.id
    version = "$Latest"
  }

}

resource "aws_s3_bucket" "cache_bucket" {
  bucket = replace("${var.instance_name}-cache", "_", "-")

  tags = {
    Name = "${var.instance_name}-cache"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.cache_bucket.id
  acl    = "private"
}
