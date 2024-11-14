#!/bin/bash

set -e

read -p "update kernel rasbberypi (y/n): " update_kernel

if [[ "$update_kernel" == "y" ]]; then
    echo -e "\e[33mWarning: 'rpi-update' should only be used if there is a specific reason to do so."
    echo -e "This installs testing versions of the kernel and firmware, which may contain bugs.\e[0m"
    echo -e "Proceed only if requested by a Raspberry Pi engineer or if you're comfortable with potential regressions and can restore your system if needed.\n"
    
    read -p "Are you sure you want to proceed with 'rpi-update'? (y/n): " confirm_update
    if [[ "$confirm_update" == "y" ]]; then
        echo -e "\e[34mUpdating kernel version\e[0m"
        sudo rpi-update
        echo -e "\e[34mKernel update completed\e[0m"

        # Prompt for reboot
        read -p "Kernel update requires a reboot. Would you like to reboot now? (y/n): " reboot_now
        if [[ "$reboot_now" == "y" ]]; then
            echo -e "\e[34mRebooting system...\e[0m"
            sudo reboot
        else
            echo -e "\e[33mPlease remember to reboot later to apply the kernel update.\e[0m"
        fi
    else
        echo -e "\e[33mKernel update cancelled.\e[0m"
    fi
fi

read -p "Would you like to install Tailscale for VPN? (y/n): " install_tailscale

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

if [[ "$install_tailscale" == "y" ]]; then
    echo -e "\e[34m Installing Tailscale\e[0m"
    curl -fsSL https://tailscale.com/install.sh | sh
    sudo tailscale up --ssh=true
    echo -e "\033[0;32mTailscale installed and configured\033[0m"
fi


# Print DONE message
echo -e "\033[0;32mDONE\033[0m"
