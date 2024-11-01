#!/bin/bash

# set -e
# 
# # Installing Nginx
# echo -e "\e[34m Instal ngnix\e[0m"
# sudo apt-get update
# sudo apt-get upgrade -y
# sudo apt-get install -y nginx
# 
# # Configuring reverse proxy
# sudo cat <<EOF > /etc/nginx/sites-available/reverse-proxy
# server {
#     listen 80;
#     # listen 53 udp;
#     # listen 53;
# 
#     resolver 127.0.0.1 valid=30s;
# 
#     location / {
#         proxy_pass http://localhost:5353;  # Port on which Pi-hole operates inside Docker container
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto \$scheme;
#     }
# }
# EOF
# 
# # Enabling reverse proxy configuration
# if [ ! -L /etc/nginx/sites-enabled/reverse-proxy ]; then
#     sudo ln -s /etc/nginx/sites-available/reverse-proxy /etc/nginx/sites-enabled/reverse-proxy
# else
#     echo "Symbolic link for reverse-proxy already exists."
# fi
# 
# Restarting Nginx server
#echo -e "\e[34m restart nginx\e[0m"
#sudo systemctl restart nginx

# install docker 
echo -e "\e[34m Docker instalation\e[0m"
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start docker
sudo systemctl start docker

# Install docker-compose
echo -e "\e[34m Install docker-compose\e[0m"
sudo apt install docker-compose -y

# Run Pi-hole in docker
docker-compose up -d

echo -e "\e[343m waiting for container\e[0m"
while true; do
    if [ $( docker ps -a | grep pihole | wc -l ) -gt 0 ]; then
        echo "Container run!!!"
        break
    else
        echo -n "."
        sleep 2
    fi
done

echo -e "\e[34m importing addlist\e[0m"
docker exec -it pihole sqlite3 /etc/pihole/gravity.db "INSERT INTO adlist (address) VALUES ('https://gitlab.com/hagezi/mirror/-/raw/main/dns-blocklists/adblock/pro.txt');"
docker exec -it pihole pihole -g

# Check for errors and retry if necessary
if [ $? -ne 0 ]; then
    echo "Error occurred while building gravity tree. Retrying in 10 seconds..."
    sleep 10
    docker exec -it pihole pihole -g
fi

# Print DONE message
echo -e "\033[0;32mDONE\033[0m"
