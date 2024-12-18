#!/usr/bin/env bash

# Must be root
if [[ $UID -ne "0" ]]; then
	echo "Must have superuser privilege to execute this script!"
	exit
fi

# Variables
host_file=$(cat /etc/hosts | grep ^127* | awk '{print }')

# Question
prompt_one() {
	while true; do
		read -p "Do you wish to rename this host? (yes/no): " prompt1
		prompt1=$(echo "$prompt1" | tr '[:upper:]' '[:lower:]')

		if [[ $prompt1 -eq "yes" || $prompt1 -eq "y"]]; then
			prompt_two
			break
		elif [[ $prompt1 -eq "no" || $prompt1 -eq "n"]]; then
			read -p -s -n 1 "Aborting process. Click any key to exit script."
			break
		else
			echo "Invalid option. Type in either 'Yes' or 'No'."
		fi
	done
}

prompt_two() {
}

# Main Script
prompt_one # You wish to continue
prompt_two # What do want the name to be
hostnamectl # Run hostnamectl
hosts_file # Edit /etc/hosts
