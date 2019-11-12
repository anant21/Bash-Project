#!/bin/bash
# Ensure that this scipt is run by the root user


#--------USER CREATION BASH SCRIPT---------
#==========================================

if [[ $(id -u) -ne 0 ]]; then
	echo "Please run this script as root"
	exit 1

fi

#Function for adding in the group

function addgrp() {
	#Ensure that the group is not already there
	if [[ $(grep -c $1 /etc/group) -eq 0 ]]; then
		#-c : counts, how many group names with the entered name present in etc/groups directory
		groupadd $1
	fi
	
}


echo "### Create New User ###"
#Get the username

while [[ -z $username ]]; do
	read -p "Username: " username
done
# User real name
read -p "User alias: " alias
if [[ ! -z $alias ]]; then
	alias="-c '$alias'"
fi

#PROJECT - 2
#=============

# Expiry Date
read -p "ExpiryDate (yyyy-mm-dd): " expirydate
if [[ ! -z $expirydate ]]; then
	expirydate="-e $expirydate"
fi

# Password inactive after
read -p "Days till password is inactive: " passwordexpiry
if [[ ! -z $passwordexpiry ]]; then
	passwordexpiry="-f $passwordexpiry"
fi

#Primary Group
read -p "Primary Group: " primarygroup
if [[ -z $primarygroup ]]; then
	primarygroup=$username
fi
addgrp $primarygroup

#Secondary Groups
read -p "Secondary groups: " secondarygroup
if [[ ! -z $secondarygroup ]]; then
	secondarygroup="$secondarygroup"
fi
addgrp $secondarygroup


#PROJECT 3
#==============

#Home directory
read -p "Home directory: " homedir
if [[ -z $homedir ]]; then
	homedir="/home/$username"
fi
mkdir $homedir
read -p "Default shell: " loginshell
if [[ ! -z $loginshell ]]; then
	loginshell="-s:$loginshell"
fi

chown $username:$primarygroup $homedir
chmod 755 $homedir

echo "New user > $username $alias $expirydate -g:$primarygroup -G:$secondarygroup -d:$homedir $loginshell  < has been created succesfully !!"

