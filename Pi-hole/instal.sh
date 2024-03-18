#!/bin/bash

# Installing Nginx
sudo apt-get update
sudo apt-get install -y nginx

# Configuring reverse proxy
sudo cat <<EOF > /etc/nginx/sites-available/reverse-proxy
server {
    listen 80;
    listen 53 udp;
    listen 53;
    67;

    resolver 127.0.0.1 valid=30s;

    location / {
        proxy_pass http://localhost:5353;  # Port on which Pi-hole operates inside Docker container
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
EOF

# Enabling reverse proxy configuration
sudo ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/reverse-proxy

# Restarting Nginx server
sudo systemctl restart nginx

# install docker 
# Downloading and adding Docker GPG key
curl -fsSL https://download.docker.com/linux/raspbian/gpg | sudo apt-key add -

# Adding Docker Engine repository for armhf architecture (Raspberry Pi)
echo "deb [arch=armhf] https://download.docker.com/linux/raspbian buster stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Updating APT package index and installing Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Adding current user to docker group to avoid needing sudo when running Docker commands
sudo usermod -aG docker $USER

# Checking installed Docker version
docker --version

# Start docker
sudo systemctl start docker

# Downloading latest version of Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

# Granting execute permissions to Docker Compose file
sudo chmod +x /usr/local/bin/docker-compose

# Checking installed Docker Compose version
docker-compose --version

# Run Pi-hole in docker
docker-compose up -d

echo "waiting for container"
while true; do
    if [ $( docker ps -a | grep testContainer | wc -l ) -gt 0 ]; then
        echo "Container run!!!"
        break
    else
        echo -n "."
        sleep 2
    fi
done

docker cp config pihole:/tmp
docker exec -it pihole sh -c "./tmp/config.sh"
