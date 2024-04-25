resource "aws_iam_policy" "openai_key_secrets_manager_access" {
  name        = "SecretsManagerAccess"
  description = "Policy that allows access to Secrets Manager"

  policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "secretsmanager:GetSecretValue",
            "Resource": [
                "arn:aws:secretsmanager:us-east-1:257603592192:secret:openai_api_key-*"
            ]
        }
    ]
    }
    EOF
}

resource "aws_iam_role" "ec2_openai_secrets_manager_role" {
  name = "EC2SecretsManagerRole"

  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "secrets_manager_attachment" {
  role       = aws_iam_role.ec2_openai_secrets_manager_role.name
  policy_arn = aws_iam_policy.openai_key_secrets_manager_access.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-instance-profile"
  role = aws_iam_role.ec2_openai_secrets_manager_role.name
}

