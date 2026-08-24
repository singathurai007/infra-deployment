terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Get latest Ubuntu 24.04 AMI
data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Get default VPC
data "aws_vpc" "default" {
  default = true
}

# Get subnets from default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create EC2 instance
resource "aws_instance" "dev_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  # AWS Key Pair name
  key_name = "python"

  subnet_id = data.aws_subnets.default.ids[0]

  tags = {
    Name        = "terraform-dev-server"
    Environment = "dev"
  }
}

output "instance_id" {
  value = aws_instance.dev_server.id
}

output "public_ip" {
  value = aws_instance.dev_server.public_ip
}
