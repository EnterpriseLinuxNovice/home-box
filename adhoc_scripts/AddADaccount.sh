#!/usr/bin/env bash


cat << "EOF"
#################################################################
#								#
#	This script ADD/REMOVES Active Directory accounts to	#
#		local groups in /etc/group.			#
#								#
#	This scripts only assumes server is joined to REALM	#
#		using the SSS Daemon (SSSD).			#		
#								#
#								#
#################################################################
EOF

prompt1() {
	echo "This scripy modifies files like group and gshadow."
	read -p "Do you wish to continue? [Yes/No] " answer
	case "$answer" in
		yes | y)
			echo "Proceeding..."; sleep 1
			main_menu
			;;
		no | n)
			echo "Aborting process..."
			exit
			;;
		*)
			echo "Invalid option. Type 'yes' or 'no'."
			exit
			;;
	esac
}

main_menu() {
	while true; do
		echo "================================="
		echo "1.) Add account to group."
		echo "2.) Remove account from group."
		echo "3.) Show existing local groups."	
		echo "4.) Query AD account."	
		echo "================================="
	read -p "--->  Select one of the options above." option
	case "$option" in
		1)
			add_account
			exit
			;;
		2)
			remove_account
			exit
			;;
		3)
			show_groups
			exit
			;;
		4)
			query_user
			exit
			;;
		*)
			echo "Invalid option. Select between [1-4]."
			;;
	esac			
	done
}

add_account() {
	read -p "Enter the username you wish to ADD: " user_add
	if ! getent passwd "$user_add" &>/dev/null; then
		echo "User's AD account ID doesn't exist or is unable to access this system."
		return
	else
		read -p "Enter the local group you wish to add TO: " group_add
		if ! grep "$group_add" /etc/group &>/dev/null; then
			echo "Local group doesn't exist."
			return
		else
			lgroupadd -M "user_add" "grou_add" &>/dev/null
			echo "User added succesfully!"
			return
		fi
	fi	
}

remove_account() {
	read -p "Enter the username you wish to REMOVE: " user_del
	if ! getent passwd "$user_del" &>/dev/null; then
		echo "User doesn't exist in system."
		return
	else
		lgroupmod -m "$user_del" "$group_add" &>/dev/null
		echo "User $user_del has been REMOVED from group."
		grpconv
		exit
	fi
}
prompt1
