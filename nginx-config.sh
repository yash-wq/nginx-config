sudo apt update
sudo apt install python3-pip python3-dev build-essential libssl-dev libffi-dev python3-setuptools
pip install requirements.txt
pip install gunicorn
gunicorn --bind 0.0.0.0:8000 app:app
