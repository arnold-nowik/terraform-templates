# --- SG for allowing SSH into ECS instance ---
resource "aws_security_group" "example-stg-sg-allow-ssh" {
  name        = "example-stg-sg-allow-ssh"
  description = "Allow SSH to ECS instance"
  vpc_id      = module.vpc.vpc_id

  ingress = [
    {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "Open port 8080 for testing"
      from_port        = 8080
      to_port          = 8080
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null

    }
  ]

  tags = {
    Name = "example-stg-ssh-sg"
  }
}

# --- RDS Security Group ---

resource "aws_security_group" "example-stg-sg-rds" {
  name        = "example-stg-sg-rds"
  description = "Allow access to RDS from ECS instance"
  vpc_id      = module.vpc.vpc_id

  ingress = [
    {
      description      = "Allow access to RDS from ECS instance"
      from_port        = 3306
      to_port          = 3306
      protocol         = "tcp"
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = [aws_security_group.example-stg-sg-allow-ssh.id]
      self             = null
    }
  ]

  egress = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      description      = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null

    }
  ]

  tags = {
    Name = "example-stg-rds-sg"
  }
}
