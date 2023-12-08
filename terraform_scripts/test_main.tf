provider "aws" {
  region  = "us-east-1"
  profile = "mehdi"
}

# Security Group
resource "aws_security_group" "nc-sg" {
  name        = "nc-sg"
  description = "Allow SSH, HTTP, HTTPS inbound traffic"

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Standard egress to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance
resource "aws_instance" "nc_instance" {
  ami                         = "ami-053b0d53c279acc90"  # Update this with the AMI you want
  instance_type               = "t2.micro"
  associate_public_ip_address = true   # Assign a public IP
  vpc_security_group_ids      = [aws_security_group.nc-sg.id]  # Attach the security group

  tags = {
    Name = "EC2_NC-${formatdate("YYYYMMDDHHmmaa", timestamp())}"
  }
}