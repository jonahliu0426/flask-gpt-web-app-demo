variable "instance_type" {
  default = "t3a.nano"
}

variable "key_name" {
  description = "The EC2 Key Pair name to allow SSH access"
}

variable "app_port" {
  default = "5000"
}

variable "openai_api_key" {
  description = "API key for OpenAI"
  type        = string
  sensitive   = true
}

variable "aws_access_key_id" {
  type = string
  sensitive = true
}

variable "aws_secret_access_key" {
  type = string
  sensitive = true
}