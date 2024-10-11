provider "aws" {
  region  = "us-east-1"
  profile = "mehdi"
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

  azs = ["us-east-1a"]
  public_subnets = ["10.0.1.0/24"]

}

# Security Group
resource "aws_security_group" "nc-sg" {
  description = "Allow SSH, HTTP, HTTPS inbound traffic"
  vpc_id = module.vpc.vpc_id

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
  ami                         = data.aws_ami.ubuntu  # Update this with the AMI you want
  subnet_id                   = module.vpc.public_subnets[0] 
  instance_type               = "t2.micro"
  associate_public_ip_address = true   # Assign a public IP
  vpc_security_group_ids      = [aws_security_group.nc-sg.id]  # Attach the security group

  tags = {
    Name = "EC2_NC-${formatdate("YYYYMMDDHHmmaa", timestamp())}"
  }
}