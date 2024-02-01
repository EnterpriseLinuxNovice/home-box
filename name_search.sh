#!/bin/bash
read -p "Who are you searching for?" name
read -p "Are they on the registry? (yes/no)" answer
if [ "$answer" == "yes" ]; then
	echo "Standby... Checking database..." && sleep 8
	if grep $name /etc/passwd; then 
		echo "User $name exists within the registry."
	else
		echo "User $name doesn't exist in registry."
	fi
elif [ "$answer" == "no" ]; then
	echo "Affirmative. User $name doesn't exist in registry!"
else
	echo "Please enter a valid entry."
fi
