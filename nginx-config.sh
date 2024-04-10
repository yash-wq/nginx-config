#!/bin/bash
sudo apt update
sudo apt install python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools
pip install -r requirements.txt
pip install gunicorn #pip install
sudo apt install nginx

user=$(whoami)

project_name=$(pwd | grep -o '[^/]*$')

python3 nginx-config/config.py $user $project_name
service_file_name="${project_name}.service"
nginx_file_name="${project_name}"
echo $service_file_name
echo $nginx_file_name
sudo cp "nginx-config/$service_file_name" "/etc/systemd/system/${project_name}.service"
#sudo systemctl daemon-reload
sudo systemctl start $project_name
sudo systemctl enable $project_name

sudo cp "nginx-config/$nginx_file_name" "/etc/nginx/sites-available/${project_name}"
sudo ln -s "/etc/nginx/sites-available/${project_name}" /etc/nginx/sites-enabled
sudo systemctl restart nginx
sudo ufw delete allow 8000
sudo ufw allow 'Nginx Full'
