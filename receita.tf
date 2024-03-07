
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "instancia01" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  depends_on = [aws_s3_bucket.bucket1]
}

#Dependencia implicita
resource "aws_eip" "teste"{
    instance = aws_instance.instancia01.id
    domain = "vpc"
}

#Dependencia explicita, ver RECURSO: resource "aws_instance" "instancia01" {...}
resource "aws_s3_bucket" "bucket1" {
  bucket = "my-tf-test-bucket-alladio"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}   