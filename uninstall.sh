#!/bin/bash

## Linux-Toolkit Uninstaller
## Simple script to remove the files that are used with Linux-Toolkit
## Author: Frazer Grant
## Uninstaller Version: 0.1.0b



filedesktop=/usr/share/applications/toolkit.desktop

pause(){
	read -n 1 -s -r -p "Press any key to continue"
}


if [ -f "$file" ]; then
sudo rm -rf /etc/Linux-toolkit
else 
exit 1 

fi 

if [ -f "$filedesktop" ]; then
sudo rm -rf /usr/share/applications/toolkit.desktop
else 
exit 1
fi


echo "Linux Toolkit has been removed"
pause
