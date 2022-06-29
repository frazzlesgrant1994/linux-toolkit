#!/bin/bash

## Linux-Toolkit 
## Tools to help add users, install/remove software and update your system
## Author: Frazer Grant

##Check config file exists and Import config file 
# Default location /etc/Linux-toolkit


configfile='config.cfg'
if [ -f ${configfile} ]; then
      echo "Reading user configuration...." >&2
      source "$configfile"
else
    echo "config.cfg has been moved or does not exist"
	exit 1
fi

 
##
#Beginnging of Functions
##

ColorGreen(){
	echo -ne $green$1$clear
}
ColorBlue(){
	echo -ne $blue$1$clears
}


pause(){

	read -r -s -p $'Press enter to continue...'
}

firsttimerun() {
if [ -f "$FILE" ]; then
clear
else 
clear
warning
touch $FILE
echo "Linux Toolkit comes with NO warranties, I am NOT responsible if you break your linux system. 
Would you like to continue with Linux Toolkit  
Accept=True" > $FILE
fi 

}

## check for update on start 

updatetool(){
read -r -p "There is an update available. Would you like to update?  [Y/n]" response
  response=${response,,} # tolower
  if [[ $response =~ ^((yes|y| )) ]] || [[ -z $response ]]; then
	    bash /etc/Linux-toolkit/update.sh
		clear 
		bash /etc/Linux-toolkit/linux-toolkit.sh
  else 
      clear
    echo ""
  fi
}



updatecheck(){
LATEST_RELEASE=$(curl -L -s -H 'Accept: application/json' $repo/releases/latest)
LATEST_VERSION=$(echo $LATEST_RELEASE | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/') 

if [ "$version" == "$LATEST_VERSION" ]; then
    echo "You are on the latest version"
    
else
    updatetool
fi 

}

#Welcome Message
welcomemsg(){
clear
echo "########################################### "$version" ############################################"
echo ""
echo "Hello $user. Welcome to the Linux Toolkit"
echo ""
echo "Todays date: $time"
echo ""
echo "OS Version: "$osver""
echo ""
echo "##############################################################################################################"
sleep 0.2
}

## Warning message
warning(){
echo "######################################################################################################"
read -r -p "# Linux Toolkit comes with NO warranties, I am NOT responsible if you break your linux system.       #
# Would you like to continue with Linux Toolkit  [Y/n]					             #
######################################################################################################" response
  response=${response,,} # tolower
  
  if [[ $response =~ ^((yes|y| )) ]] || [[ -z $response ]]; then
	    clear 
  else 
      clear
    exit 1
  fi
}

############################################################################ Main Menu #########################################
menu(){
welcomemsg	

echo -ne "
Linux Toolkit
$(ColorGreen '1)') System Information
$(ColorGreen '2)') Users and Groups
$(ColorGreen '3)') ... 
$(ColorGreen '4)') Update System
$(ColorGreen '5)') Remove Software
$(ColorGreen '6)') Install Software
$(ColorGreen '7)') Run Command
$(ColorGreen 'a)') About
$(ColorGreen 'q)') Exit
$(ColorGreen 'Choose an option:') "
        read a
        case $a in
            1) sysinfo ; menu ;;
	        2) usermanager ; menu;;
	        3) ... ; menu ;;
            4) sysupdate ; menu ;;
	        5) removesoftware; menu ;;
			6) installsoftware; menu ;;
			7) runcommand; menu ;;
			a) about; menu ;;
		q) exit 0 ;;
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
$(ColorGreen 'q)') Exit
$(ColorGreen 'Choose an option:') "
        read a
        case $a in
            1)  clear && ip a && pause ; clear && sysinfo ;;
	        2)  clear && uname -a && pause ; clear && sysinfo ;;
	        3) ... ; menu ;;
            4) ... ; menu ;;
	        5) ... ; menu ;;
			0) menu ;;
			q) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}


# User Manager
usermanager(){	
clear
welcomemsg	
echo -ne "
User And Group Management 
$(ColorGreen '1)') Add User
$(ColorGreen '2)') Remove User
$(ColorGreen '3)') Change Password
$(ColorGreen '4)') Add Group
$(ColorGreen '5)') Remove Group 
$(ColorGreen '6)') Add User To Group
$(ColorGreen '7)') Remove User From Group
$(ColorGreen '0)') Back
$(ColorGreen 'q)') Exit
$(ColorGreen 'Choose an option:') "
        read a
        case $a in
            1)  addusr ; clear && sysinfo ;;
	        2)  removeuser ; clear && sysinfo ;;
	        3) ... ; menu ;;
            4) ... ; menu ;;
	        5) ... ; menu ;;
		    6) ... ; menu ;;
	        7) ... ; menu ;;
			0) menu ;;
			q) exit 0 ;;
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
		sudo apt update
		sudo apt upgrade
## Fedora
	elif command -v dnf &> /dev/null
	then
		sudo dnf check-update
		sudo dnf upgrade

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
## Fedora
	elif command -v dnf &> /dev/null
	then
		sudo dnf remove $remove
	fi

}
## Install Software
installsoftware(){
## Arch Based
read -r -p 'What software do you want to Install?: ' install
	if command -v pacman &> /dev/null
	then
		sudo pacman -S $install versioninfo
	fi

}
runcommand(){
welcomemsg
echo "" 
read -r -p  'Enter Command: ' command
$command
echo ""
pause


}




# About
about(){	
clear
welcomemsg	
echo -ne "
About
$(ColorGreen '1)') Version information
$(ColorGreen '2)') Licence 
$(ColorGreen '3)') ...
$(ColorGreen '4)') ...
$(ColorGreen '5)') ...
$(ColorGreen 'u)') Check for updates
$(ColorGreen '0)') Back
$(ColorGreen 'q)') Exit
$(ColorGreen 'Choose an option:') "
        read a
        case $a in
            1) versioninfo ; about ;;
	        2) licensefunc ; about ;;
	        3) ... ; menu ;;
            4) ... ; menu ;;
	        5) ... ; menu ;;
			u) updatecheck && pause ; menu ;;
			0) menu ;;
			q) exit 0 ;;
		*) echo -e $red"Wrong option."$clear; WrongCommand;;
        esac
}

versioninfo(){
clear	
welcomemsg	
echo ""
echo "Version: $version "
echo ""
echo "Release Notes: $repo/releases/$version"	
echo ""
pause
}

licensefunc(){
clear 
cat /etc/Linux-toolkit/LICENSE.md
echo ""
pause
clear
}


##### #####
updatecheck
firsttimerun
menu