terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "sg_1" {
  name = "default"

  ingress {
    description = "App Port"
    from_port   = 8000
    to_port     = 8000
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

resource "aws_key_pair" "puthea_key" {
  key_name   = "puthea-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/0VxujSAj5pYR95+bgTd6+XXPAffHVR8OPAsBjJGJgmIuoelKK3uHWryYoEZaa3BIFkRKR71sQ0inpsGI8IFVT7JsYPTk46MqGWzFIiAvz551i4TFfqeFiZh5neTWDmQLefT0bIPWPHKFe9gbvrihwT6OfQfqrqw+JAN1jCo/BbRAxXs60tE/itbnwzkS5VzdwGJLauNl0o6O2OamogO0EZPjMAlSfnJuc+7W0UcQZz4nT3gYgqQ+irvHmOo9aI/YZX8ovnERFMG9foZ8V7x08hsgsENXCtuH/KMntLVHMWYclyBzkXzRkGt3XYz8P3K10Xc7WPj3cQSaT7d8Pm2x puthea@LAPTOP-JVK7B2K6"
}

resource "aws_instance" "server_1" {
  ami                         = "ami-ff0fea8310f3"
  instance_type               = "t3.micro"
  count                       = 3
  key_name                    = aws_key_pair.puthea_key.key_name
  security_groups             = [aws_security_group.sg_1.name]
  # user_data                   = <<-EOF
  #             #!/bin/bash
  #             apt update -y
  #             apt install git -y
  #             apt install curl -y

  #             # Install NVM
  #             curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  #             . ~/.nvm/nvm.sh

  #             # Install Node.js 18
  #             nvm install 18

  #             # Install PM2
  #             npm install pm2 -g

  #             # Clone Node.js repository
  #             git clone https://github.com/Soputhea/DevOps.git /root/devops-ex

  #             # Navigate to the repository and start the app with PM2
  #             cd /root/devops-ex
  #             npm install
  #             pm2 start app.js --name node-app -- -p 8000
  #           EOF
  user_data_replace_on_change = true
  user_data                   = <<-EOF
              #!/bin/bash
              apt update -y
              apt install python3 -y
              EOF
}