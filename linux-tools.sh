#!/bin/bash

green='\e[32m'
blue='\e[34m'
clear='\e[0m'

user=$(whoami)
workdir=$(pwd)
time=$(date)




##
#Functions
##

ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clear
}

pause(){

	read -n 1 -s -r -p "Press any key to continue"
}

hide(){
welcomemsg

echo ""
echo "Edit $workdir/linux-toolkit.sh and comment out "warning" on line 64 "
echo ""
pause
}


#Welcome Message
welcomemsg(){
clear
echo "Hello $user. Welcome to the Linux Toolkit"
echo ""
echo "Todays date is $time"
echo ""
echo "Author: Frazer  Grant"
echo "Version: 0.5"
sleep 0.5
}
warning(){
read -r -p "Linux Toolkit comes with NO warranties, I am NOT responsible if you break your linux system. 
Would you like to continue with Linux Toolkit  [Y/n] " response
  response=${response,,} # tolower
  if [[ $response =~ ^((yes|y| )) ]] || [[ -z $response ]]; then
	    clear 
  else 
      clear
    exit 1
  fi
}

############################################################################ Main Menu #########################################
#warning
menu(){
welcomemsg	
echo -ne "
Linux Toolkit
$(ColorGreen '1)') System Information
$(ColorGreen '2)') Add User
$(ColorGreen '3)') Remove User 
$(ColorGreen '4)') Update System
$(ColorGreen '5)') Remove Software
$(ColorGreen '6)') Install Software
$(ColorGreen 'h)') Hide warning message
$(ColorGreen 'a)') About
$(ColorGreen '0)') Exit
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
            1) sysinfo ; menu ;;
	        2) addusr ; menu;;
	        3) removeuser ; menu ;;
            4) sysupdate ; menu ;;
	        5) removesoftware; menu ;;
			6) installsoftware; menu ;;
			h) hide; menu ;;
			a) about; menu ;;
		0) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}



# System Information
sysinfo(){	
clear
welcomemsg	
echo -ne "
System Information
$(ColorGreen '1)') Network
$(ColorGreen '2)') Kernal Version
$(ColorGreen '3)') ...
$(ColorGreen '4)') ...
$(ColorGreen '5)') ...
$(ColorGreen '0)') Back
$(ColorBlue 'Choose an option:') "
        read a
        case $a in
            1)  clear && ip a && pause ; clear && sysinfo ;;
	        2)  clear && uname -a && pause ; clear && sysinfo ;;
	        3) ... ; menu ;;
            4) ... ; menu ;;
	        5) ... ; menu ;;
			0) menu ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

# Add User function
addusr(){
# Create Username
	clear
		read -r -p 'Create username: ' uname
	clear
# Check is User exists
	getent passwd $uname > /dev/null 2&>1
	if [ $? -eq 0 ]; then
			echo "yes the user exists"
		pause
		addusr
	else
		echo "creating user"
		sudo useradd --create-home $uname
		sudo passwd $uname
		sudo usermod -aG wheel $uname
	fi
# Check Creation of account
	getent passwd $uname > /dev/null 2&>1
	if [ $? -eq 0 ]; then
			clear
			echo "$uname has been added"
		pause
	else
		clear
		echo "Failed to create account for $uname"
		pause
		addusr	
	fi
}
## End of addusr 
## Remove User
removeuser(){
clear
# Get info
read -r -p 'Enter the account you want to remove: ' rname
clear
read -r -p "Are you sure you want to remove $rname? [Y/n] " response
response=${response,,} # tolower
if [[ $response =~ ^((yes|y| )) ]] || [[ -z $response ]]; then 
echo "Removing user"
clear
else
menu
fi
	getent passwd $uname > /dev/null 2&>1
	if [ $? -eq 0 ]; then
			clear
			echo "Account for $rname has been found "
		sleep 2
	else
		clear
		echo "No account found for $rname"
		pause
		removeuser
	fi
	read -r -p "Do you want to delete the home folder for $rname? [Y/n] " response
	response=${response,,} # tolower
	if [[ $response =~ ^((yes|y| )) ]] || [[ -z $response ]]; then 
		sudo userdel -f -r $rname
		clear
		
	else
		sudo userdel -f $rname
		
	fi
		getent passwd $uname > /dev/null 2&>1
	if [ $? -eq 0 ]; then
			clear
			echo "Failed to remove $rname"
		pause
	else
		clear
		echo "$rname has been removed"
		pause
		menu
	fi
}
## End of remove user 
## System Update

sysupdate(){
## Arch Based
	if command -v pacman &> /dev/null
	then
		sudo pacman -Syu
## Debian Based
	elif command -v apt-get &> /dev/null
	then
		sudo apt update && apt upgrade
	fi
}
## End of System update
## Remove Software
removesoftware(){
## Arch Based
read -r -p 'What software do you want to remove?: ' remove
	if command -v pacman &> /dev/null
	then
		sudo pacman -Rns $remove
		pause
## Debian Based
	elif command -v apt-get &> /dev/null
	then
		sudo apt purge --auto-remove $remove
	fi

}
## Install Software
installsoftware(){
## Arch Based
read -r -p 'What software do you want to Install?: ' install
	if command -v pacman &> /dev/null
	then
		sudo pacman -S $install
## Debian Based
	elif command -v apt-get &> /dev/null
	then
		sudo apt install $install
	fi

}
# Call the menu function
about(){
clear
welcomemsg
echo "About Page"
pause
}
menu

