#!/bin/bash



pause(){
	read -n 1 -s -r -p "Press any key to continue"
}


sudo mkdir /etc/Linux-toolkit
sudo mv linux-toolkit.sh /etc/Linux-toolkit/
sudo mv tool.jpg /etc/Linux-toolkit/
sudo mv Toolkit.desktop /usr/share/applications/
echo "Installed"
pause
