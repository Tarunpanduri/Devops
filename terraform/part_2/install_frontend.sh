set -e

BACKEND_Private_IP="${backend_ip}"

echo "--- Installing Frontend Dependencies ---"
apt-get update -y
apt-get install -y nodejs npm git

cd /home/ubuntu
if [ ! -d "docker_flask" ]; then
    git clone https://github.com/Tarunpanduri/docker_flask.git
fi

cd docker_flask/frontend

npm install

export BACKEND_URL="http://$BACKEND_Private_IP:5000"

echo "Backend URL set to: $BACKEND_URL"

nohup node index.js > frontend.log 2>&1 &