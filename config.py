
import os
import sys//importing
env_name = input("Enter the name of the virtual environment: ")
domain = input("Enter the domain you have configured to the IP: ")
user = sys.argv[1]
project_name = sys.argv[2]

service_file_contents = f"""
[Unit]
Description=Gunicorn instance to serve myproject
After=network.target

[Service]
User={user}
Group=www-data
WorkingDirectory=/home/{user}/{project_name}
Environment="PATH=/home/{user}/{project_name}/{env_name}/bin"
ExecStart=/home/{user}/{project_name}/{env_name}/bin/gunicorn --workers 1 --bind unix:{project_name}.sock -m 007 app:app

[Install]
WantedBy=multi-user.target
"""
with open(f"nginx-config/{project_name}.service", 'w') as f:
    f.write(service_file_contents)

nginx_contents = """
server {
    listen 80;
    server_name """ + domain + """ ;

    location / {
        include proxy_params;
        proxy_pass http://unix:/home/"""+user+"""/"""+project_name+"""/"""+project_name+""".sock;
    }
}
"""
with open(f"nginx-config/{project_name}", 'w') as f:
    f.write(nginx_contents)
