set -e

MONGO_URI_VAL="${mongo_uri}"

echo "--- Installing Backend Dependencies ---"
apt-get update -y
apt-get install -y python3-pip python3-venv git

cd /home/ubuntu
if [ ! -d "docker_flask" ]; then
    git clone https://github.com/Tarunpanduri/docker_flask.git
fi

cd docker_flask/backend

echo "MONGO_URI='$MONGO_URI_VAL'" > .env

python3 -m venv venv

./venv/bin/pip install -r requirements.txt


nohup ./venv/bin/python3 app.py > backend.log 2>&1 &