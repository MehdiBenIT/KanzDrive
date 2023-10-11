provider "aws" {
  region = "us-west-2"  # Choose your desired AWS region
}

# EC2 instance
resource "aws_instance" "my_instance" {
  ami           = "ami-01103fb68b3569475"  # Update this with the AMI you want
  instance_type = "t2.micro"

  tags = {
    Name = "EC2_NC"
  }
}

# RDS instance
resource "aws_db_instance" "my_db_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "mydb"
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  tags = {
    Name = "DB_NC"
  }
}
