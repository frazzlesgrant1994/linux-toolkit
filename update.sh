#!/bin/bash
## Linux-Toolkit Updater
## Simple script to update Linux Toolkit
## Author: Frazer Grant
## Version: 0.6b


pause(){
	read -n 1 -s -r -p "Press any key to continue"
}

## Check for updates
currentversion=Linux-Toolkit-V0.6b


LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' https://github.com/frazzlesgrant1994/linux-toolkit/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/') 

if [ "$currentversion" == "$LATEST_VERSION" ]; then
    echo "Linux Toolit is upto date, Version = $LATEST_VERSION"
    pause
    exit 1
else
clear
fi 

## Temp Dir
Temp=~/temp

if [ -f "$Temp" ]; then
    echo ""
else
    mkdir ~/temp
fi 

cd ~/temp


## Download update file 

wget https://github.com/frazzlesgrant1994/linux-toolkit/releases/download/$LATEST_VERSION/$LATEST_VERSION.tar.gz

## Extract and remove tar file
tar -xzf $LATEST_VERSION.tar.gz
rm -rf  $LATEST_VERSION.tar.gz

## Move updated files to the specified locations
sudo mv linux-toolkit.sh /etc/Linux-toolkit/
sudo mv update.sh /etc/Linux-toolkit/
sudo mv  tool.jpg /etc/Linux-toolkit/
sudo mv  toolkit.desktop /usr/share/applications/

## Setting Permissions for the specified  files
sudo chmod +rwx /etc/Linux-toolkit/linux-toolkit.sh

## Removeing  Temp Dir and toolsaccept file   
tools=~/.toolsaccept.txt
rm -rf ~/temp

if [ -f "$tools" ]; then
    rm -rf $tools
else
   echo ""
fi 

clear
echo""
	echo "Linux Toolkit has been updated"
pause