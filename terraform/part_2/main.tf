provider "aws" {
  region = var.aws_region
}


resource "aws_security_group" "backend_sg" {
  name        = "part2-backend-sg"
  description = "Allow SSH and Internal Traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "App Port (Flask)"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "frontend_sg" {
  name        = "part2-frontend-sg"
  description = "Allow SSH and Web Traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Web Access (Node)"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "backend" {
  ami             = "ami-02b8269d5e85954ef"
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.backend_sg.name]

  user_data = templatefile("${path.module}/install_backend.sh", {
    mongo_uri = var.mongo_uri
  })

  tags = { Name = "Flask-Backend-Part2" }
}

resource "aws_instance" "frontend" {
  ami             = "ami-02b8269d5e85954ef" 
  instance_type   = var.instance_type
  key_name        = var.key_name
  security_groups = [aws_security_group.frontend_sg.name]

  depends_on = [aws_instance.backend]

  user_data = templatefile("${path.module}/install_frontend.sh", {
    backend_ip = aws_instance.backend.private_ip
  })

  tags = { Name = "Node-Frontend-Part2" }
}