provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  description = "Allow inbound traffic for Flask and Nginx"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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

resource "aws_instance" "app_instance" {
  ami           = "ami-0dbc3d7bc646e8516" # Amazon Linux 2 AMI
  instance_type = "t2.micro"
  key_name      = "kube"
  security_groups = [aws_security_group.app_sg.name]

user_data = <<-EOF
              #!/bin/bash
              # SSH Configuration for GitHub
              mkdir -p /root/.ssh
              cp ssh-key/id_rsa /root/.ssh/id_rsa
              cp ssh-key/id_rsa.pub /root/.ssh/id_rsa.pub
              chmod 600 /root/.ssh/id_rsa
              ssh-keyscan github.com >> /root/.ssh/known_hosts
              yum update -y
              yum install git -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              yum install -y python3 git
              pip3 install Flask gunicorn
              git clone [git@github.com:kiriti07/signiance.git] /var/www/app
              cd /var/www/app
              nohup gunicorn app:app &

              # Nginx Configuration
              echo 'server {
                  listen 80;
                  server_name testapp.signiance.com;
                  
                  location / {
                      proxy_pass http://127.0.0.1:8000;
                      proxy_set_header Host $host;
                      proxy_set_header X-Real-IP $remote_addr;
                  }
              }' > /etc/nginx/conf.d/flaskapp.conf
              systemctl restart nginx

              # SSL Configuration using Certbot
              yum install -y certbot python-certbot-nginx
              certbot --nginx -d testapp.signiance.com
              EOF

  tags = {
    Name = "FlaskAppInstance"
  }
}
