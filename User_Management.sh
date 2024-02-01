#!/bin/bash
fin=0
#banner
echo "###########################################################################################################################################"
echo "Welcome to the user management tool. This tool is used for managing user accounts to include Adding, Deleting, & Modifying user settings."
echo "###########################################################################################################################################"
echo
#Options
while [ $fin -ne 1 ]
do
echo "Select the function you wish to perform:"
echo "========================================="
echo "1 - Add a user."
echo "2 - Delete a user."
echo "3 - Update User Password"
echo "4 - Unlock a user account"
echo "0 - Exit."
echo "========================================="
echo
read options;
case $options in
	1) read -p "Are you sure you want to continue with adding user? (yes/no): " add_user
		if [ "$add_user" == "yes" ]; then
			read -p "Enter username: " add_name
			if grep $add_name /etc/passwd; then
				read -sn1 -p "User already exists. Click any key to return to the main menu."
			else
				echo "Standby adding user $add_name now..." && sleep 5
				sudo useradd $add_name && echo "User $add_name has been added."
			fi
		elif [ "$add_user" == "no" ]; then
			read -sn1 -p "Click any key to return to main menu."
		else
			echo "An error has occured. Please input a valid entry."
		fi;;
	2) read -p "Are you sure you want to continue with deleting user? (yes/no): " del_user
		if [ "$del_user" == "yes" ]; then
                        read -p "Enter username: " del_name
                        if grep $del_name /etc/passwd; then
                                echo "User $del_name has was found. Will now delete user from registry."
				sleep 4
				sudo userdel -r $del_name && echo "User $del_name has been removed from registry."
                        else
                                echo "User $del_name does not exist in registry. Re-check spelling and try again."
				read -sn1 -p "Click any button to continue back to Main Menu."
			fi
                elif [ "$del_user" == "no" ]; then
                        read -sn1 -p "Click any key to return to main menu."
                else
                        echo "An error has occured. Please input a valid entry."
                fi;;
	0) echo "Now exiting script!"
	   sleep 6 && fin=1 ;;
esac
done
