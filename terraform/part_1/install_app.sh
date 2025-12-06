set -e  

MONGO_URI_VAL="${mongo_uri}"
BACKEND_PORT_VAL="${backend_port}"

echo "--- Installing Dependencies ---"
apt-get update -y
apt-get install -y python3-pip python3-venv nodejs npm git

echo "--- Cloning Repository ---"
cd /home/ubuntu
if [ ! -d "docker_flask" ]; then
    git clone https://github.com/Tarunpanduri/docker_flask.git
fi
cd docker_flask

echo "--- Setting up Backend ---"
cd backend

echo "MONGO_URI='$MONGO_URI_VAL'" > .env


python3 -m venv venv

./venv/bin/pip install flask flask-cors pymongo python-dotenv


nohup ./venv/bin/python3 app.py > backend.log 2>&1 &

echo "--- Setting up Frontend ---"
cd ../frontend

npm install


export BACKEND_URL="http://127.0.0.1:$BACKEND_PORT_VAL"

nohup node index.js > frontend.log 2>&1 &

echo "--- Deployment Complete ---"