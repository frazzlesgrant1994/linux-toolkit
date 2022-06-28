#!/bin/bash
## Linux-Toolkit Installer
## Simple script to copy files to a location that allows any user on the system to access and use the tool 
## Author: Frazer Grant
## Version: 0.1.5b


# File locations
shfile=/etc/Linux-toolkit/linux-toolkit.sh
iconfile=/etc/Linux-toolkit/tool.jpeg
filedesktop=/usr/share/applications/toolkit.desktop



pause(){
	read -n 1 -s -r -p "Press any key to continue"
}


# Checking if the .sh file existes
if [ -f "$shfile" ]; then
	echo "Linux-toolkit.sh is already installed "
else 
	sudo mkdir /etc/Linux-toolkit
	sudo cp linux-toolkit.sh /etc/Linux-toolkit/
	sudo cp update.sh /etc/Linux-toolkit/
	sudo cp LICENSE.md /etc/Linux-toolkit/
fi 


# Checking if the icon existes
if [ -f "$iconfile" ]; then
	echo "Linux-toolkit Icons already installed"
else 
	sudo cp  tool.jpg /etc/Linux-toolkit/
fi 


# Checking if the .desktop file existes
if [ -f "$filedesktop" ]; then
	echo "Linux-toolkit shortcut already installed"
else 
	sudo cp  toolkit.desktop /usr/share/applications/
fi

	sudo chmod +rwx /etc/Linux-toolkit/linux-toolkit.sh

	echo "Linux Toolkit has been Installed"
pause
