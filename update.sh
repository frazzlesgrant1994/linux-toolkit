#!/bin/bash
## Linux-Toolkit Updater
## Simple script to update Linux Toolkit
## Author: Frazer Grant
## Version: 1.0


pause(){
	read -n 1 -s -r -p "Press any key to continue"
}

## Check for updates
currentversion=Linux-Toolkit-V1.1

LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/frazzlesgrant1994/linux-toolkit/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/') 

if [ "$currentversion" == "$LATEST_VERSION" ]; then
    echo "Linux Toolit is upto date, Version = $LATEST_VERSION"
    pause
    exit 1
else
clear
fi 

## applying update 
Temp=~/temp

if [ -f "$Temp" ]; then
    echo ""
else
    mkdir ~/temp
fi 

cd ~/temp
wget https://github.com/frazzlesgrant1994/linux-toolkit/releases/download/$LATEST_VERSION/$LATEST_VERSION.tar.gz
tar -xzf $LATEST_VERSION.tar.gz
rm -rf  $LATEST_VERSION.tar.gz
sudo mv linux-toolkit.sh /etc/Linux-toolkit/
sudo mv update.sh /etc/Linux-toolkit/
sudo mv  tool.jpg /etc/Linux-toolkit/
sudo mv  toolkit.desktop /usr/share/applications/
sudo chmod +rwx /etc/Linux-toolkit/linux-toolkit.sh
rm -rf ~/temp
rm -rf ~/.toolsaccept.txt
clear
echo""
	echo "Linux Toolkit has been updated"
pause