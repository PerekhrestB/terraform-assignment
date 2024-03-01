terraform {
  cloud {
    organization = "bp-assignment"

    workspaces {
      name = "bp-tf-assignment"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "ubuntu-linux-2204" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.ubuntu-linux-2204.id
  instance_type = "t2.micro"

  tags = {
    Name = var.instance_name
  }
  user_data = <<-EOF
    #!/bin/bash
    echo 'foo' > /home/ubuntu/hello-world.txt
  EOF
}
