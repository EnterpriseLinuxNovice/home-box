#!/usr/bin/env bash

# Must be root
if [[ $UID -ne "0" ]]; then
	echo "Must have superuser privilege to execute this script!"
	exit
fi

# Variables
host_file=$(grep ^127 /etc/hosts | awk '{print $2}')
time_stamp=$(date +"%Y-%m-%d_%H:%M:%S")

# Question
load() {
	echo -n "Loading"
    	for i in {1..3}; do
        	echo -n "."
        	sleep 0.5  # Adjust the delay to your preference
    	done
    	echo ""  # Newline after the dots
}

prompt_one() {
	while true; do
		read -p "Do you wish to rename this host? (Yes|No): " prompt1
		prompt1=$(echo "$prompt1" | tr '[:upper:]' '[:lower:]')

		if [[ $prompt1 == "yes" || $prompt1 == "y" ]]; then
			echo "Proceeding with system rename..."
			break
		elif [[ $prompt1 == "no" || $prompt1 == "n" ]]; then
			echo "Aborting process. Click any key to exit script."
			read -n 1
			exit 0
		else
			echo "Invalid option. Type in either 'Yes' or 'No'."
		fi
	done
}

prompt_two() {
	echo ""
	while true; do
	read -p "Enter the desired name for host: " hostname
	echo ""
	read -p "Re-enter desired hostname to confirm: " confirm
	if [[ "$confirm" != "$hostname" ]]; then
		echo "Hostname's do not match."
		echo "Re-enter both names or hit CTRL+C to cancel."
	else
		echo "Confirmation successful! Proceeding with system rename..."
		break
	fi
	done
}

backup_file() {
	cp /etc/hosts /etc/hosts.bak_$time_stamp
	echo "Backup of /etc/hosts created as /etc/hosts.bak"
}

hostnamectl() {
	echo "$hostname" > /etc/hostname
}

hosts_file() {
	escaped_host_file=$(printf '%s\n' "$host_file" | sed 's/[&/\]/\\&/g')
        escaped_hostname=$(printf '%s\n' "$hostname" | sed 's/[&/\]/\\&/g')

	echo "Old hostname: $escaped_host_file"
        echo "New hostname: $escaped_hostname"
	echo "Click any key to continue..."
	read -n 1

	sed -i "s/$escaped_host_file/$escaped_hostname/" /etc/hosts &>/dev/null &&
	systemctl restart NetworkManager
	echo "Changes made successfully!"
}

# Main Script
prompt_one # You wish to continue
load
prompt_two # What do want the name to be
load
backup_file
load
hostnamectl # Hostnamectl
hosts_file # /etc/hosts
