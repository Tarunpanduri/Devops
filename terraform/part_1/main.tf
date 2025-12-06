provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "app_sg" {
  name        = "flask-node-single-instance-sg"
  description = "Allow SSH and App traffic"

  ingress {
    description = "SSH Access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Frontend Access"
    from_port   = var.frontend_port
    to_port     = var.frontend_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Backend Access (Optional - for debugging)"
    from_port   = var.backend_port
    to_port     = var.backend_port
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

resource "aws_instance" "app_server" {
  ami           = "ami-02b8269d5e85954ef" 
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.app_sg.name]

  user_data = templatefile("${path.module}/install_app.sh", {
    mongo_uri    = var.mongo_uri
    backend_port = var.backend_port
  })

  tags = {
    Name = "Flask-Node-Monolith"
  }
}