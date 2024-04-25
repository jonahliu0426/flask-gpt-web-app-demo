data "aws_caller_identity" "current" {}

resource "aws_secretsmanager_secret" "api_key_secret" {
  name        = "openai_api_key"
  description = "API Key for accessing My OPENAI API"
}

resource "aws_secretsmanager_secret_version" "api_key" {
  secret_id     = aws_secretsmanager_secret.api_key_secret.id
  secret_string = jsonencode({
    "api_key" = "${var.openai_api_key}"
  })
}

resource "aws_security_group" "app_sg" {
  name        = "flask_app_sg"
  description = "Allow web and SSH traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "FlaskAppSecurityGroup"
  }
}

resource "aws_instance" "app" {
  ami           = "ami-0a1179631ec8933d7" # Example AMI ID for Amazon Linux 2
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.app_sg.name]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  depends_on = [ aws_secretsmanager_secret.api_key_secret ]
  user_data = <<-EOF
                #!/bin/bash
                # Deployed at ${timestamp()}
                sudo yum update -y
                sudo amazon-linux-extras install docker

                sudo service docker start
                sudo systemctl enable docker
                sudo usermod -aG docker ec2-user
                
                aws configure set aws_access_key_id ${var.aws_access_key_id}
                aws configure set aws_secret_access_key ${var.aws_secret_access_key}
                aws configure set default.region us-east-1
                aws configure set default.output json

                docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com
                docker pull ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/my-flask-app:latest
                docker run -d -p 5000:5000 --restart=always ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/my-flask-app:latest
                EOF

  tags = {
    Name = "FlaskAppInstance"
  }
}
