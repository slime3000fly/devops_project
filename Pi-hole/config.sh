apt update
apt upgrade -y
apt install wget -y

# pihole_restore
wget https://github.com/chamilad/pihole-restore/releases/download/v0.1.0/pihole_restore-v0.1.0-linux-x86_64
wget https://github.com/chamilad/pihole-restore/releases/download/v0.1.0/pihole_restore-v0.1.0-linux-x86_64.sig
wget https://github.com/chamilad/pihole-restore/releases/download/v0.1.0/cosign-v0.1.0.pub

cosign verify-blob --key cosign-v0.1.0.pub --signature pihole_restore-v0.1.0-linux-x86_64.sig pihole_restore-v0.1.0-linux-x86_64

chmod +x pihole_restore-v0.1.0-linux-x86_64

pihole_restore -h
pihole_restore -f /tmp/pi-hole_restore.tar.gz -c

cd /tmp && wget -q https://github.com/koljah-de/pi-hole-adlists-updater/archive/master.zip -O pi-hole-adlists-updater-master.zip && unzip -q pi-hole-adlists-updater-master.zip && cd pi-hole-adlists-updater-master && sudo ./install.sh && cd .. && rm -r pi-hole-adlists-updater-master*

# file="/path/to/file"

# # Check if file exist
# if [ -f "$file" ]; then
#     # Find line with '# pihole -g' and uncomment it
#     sed -i '/# pihole -g/s/^#//' "$plik"
#     echo "Linie z '# pihole -g' done"
# else
#     echo "File '$file' doesn't exist"
# fi