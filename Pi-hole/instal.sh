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
echo "restart nginx"
sudo systemctl restart nginx

# install docker 
echo "Docker instalation"
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start docker
sudo systemctl start docker

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
docker cp pi-hole_restore.tar.gz pihole:/tmp
docker exec -it pihole sh -c "./tmp/config.sh"
