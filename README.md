# signiance
app
--Terraform

sudo FLASK_APP=app.py FLASK_RUN_HOST=0.0.0.0 flask run


to set nginx on port 80 for the application:

vi sudo nano /etc/nginx/conf.d/flask_app.conf
# Add the below content in flast_app.conf
server {
    listen 80;
    server_name ec2-54-81-94-224.compute-1.amazonaws.com;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}

# Run below commands

sudo nginx -t
sudo systemctl start nginx
sudo systemctl enable nginx
