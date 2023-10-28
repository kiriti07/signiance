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
	      yum install wget unzip -y
	      curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
	      unzip awscliv2.zip
	      ./aws/install -y
              mkdir -p /root/.ssh
	      mkdir -p /root/.aws
              mkdir -p /home/ec2-user/.ssh
	      mkdir -p /home/ec2-user/.aws
              touch /root/credentials
              touch /home/ec2-user/credentials
              echo "export AWS_ACCESS_KEY_ID=${var.aws_access_key}" >> /home/ec2-user/.aws/credentials
              echo "export AWS_SECRET_ACCESS_KEY=${var.aws_secret_key}" >> /home/ec2-user/.aws/credentials
              aws s3 cp s3://ssh-key-1/ssh-key/id_rsa /root/.ssh/
              aws s3 cp s3://ssh-key-1/ssh-key/id_rsa.pub /root/.ssh/
              aws s3 cp s3://ssh-key-1/ssh-key/id_rsa /home/ec2-user/.ssh/
              aws s3 cp s3://ssh-key-1/ssh-key/id_rsa.pub /home/ec2-user/.ssh/
              chmod 600 /root/.ssh/id_rsa
              chmod 600 /home/ec2-user/.ssh/id_rsa
              ssh-keyscan github.com >> /root/.ssh/known_hosts
              yum update -y
              yum install git -y
              yum install -y nginx
              systemctl start nginx
              systemctl enable nginx
              yum install -y python3 git
	      yum install python3-pip -y
              pip3 install Flask gunicorn
              git clone git@github.com:kiriti07/signiance.git /var/www/app
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
