terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0" # or another known stable version
    }
  }
}


provider "aws" {
  region  = "us-east-1"
  profile = "mehdi"
}

resource "aws_key_pair" "ec2_key" {
  key_name   = "my-ec2-key"
  public_key = file("~/.ssh/my-ec2-key.pub")
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-kanzdrive"
  cidr = "10.0.0.0/16"

  azs            = ["us-east-1a"]
  public_subnets = ["10.0.1.0/24"]

}

# Security Group
resource "aws_security_group" "nc-sg" {
  description = "Allow SSH, HTTP, HTTPS inbound traffic"
  vpc_id      = module.vpc.vpc_id

  name = join("_", ["sg", module.vpc.vpc_id])
  dynamic "ingress" {
    for_each = var.rules
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cidr_blocks = ingress.value["cidr_blocks"]
    }
  }

  # Standard egress to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "KanzDrive-SG"
  }
}

# EC2 instance
resource "aws_instance" "nc_instance" {
  ami                         = data.aws_ami.ubuntu.id
  subnet_id                   = module.vpc.public_subnets[0]
  instance_type               = "t2.micro"
  associate_public_ip_address = true # Assign a public IP
  key_name                    = aws_key_pair.ec2_key.key_name
  vpc_security_group_ids      = [aws_security_group.nc-sg.id] # Attach the security group
  user_data                   = <<EOF
  #!/bin/bash
  sudo apt update -y
  sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt update -y
  sudo apt install docker-ce docker-ce-cli containerd.io -y
  sudo docker --version   
  EOF

  tags = {
    Name = "EC2_NC-${formatdate("YYYYMMDDHHmmaa", timestamp())}"
  }
}