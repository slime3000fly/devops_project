# This is repo wich script to automate home-lab server instalation
##What will be instaled
- Pi-hole
- taiscalevp
- HomePage
##Requirements
To set up Pi-hole using this script, you should have a Debian-based operating system.
Installation
1. Clone this repository.
2. Run the following command to execute the installation script:
   ```bash
   bash install.sh
This script will:  
    - Install Docker.    
    - Set up the Pi-hole container.    
    - Insert a specified URL into the adlist database.  


# Helpfull link and advice how to configure pi-hole
## Adlist updater:
    https://github.com/koljah-de/pi-hole-adlists-updater
## Pi-hole restore CLI
    https://github.com/chamilad/pihole-restore
## Update Rasbbery-pi kernetl
https://github.com/raspberrypi/linux/issues/6170
## Docker container ip
docker inspect \
  -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id

# TODO:
- add homepage for entire setup
- add nas server
