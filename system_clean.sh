#!/usr/bin/env bash
package="nano"

check() {
	if rpm -q "$package"&>/dev/null; then
		echo "We detect trash!!!"; sleep 1
	else
		echo "System is clean..."; exit 1
	fi
}
prompt() {
	read -p "Do you wish to cleanse your system of any BULLSHIT? [y/n] " answer
	answer=$(echo $answer | tr '[:upper:]' '[:lower:]')
	if [[ "$answer" == "n" ]]; then
		echo "Too bad we cleaning shit!"; sleep 1
		remove_nano $package
	elif [[ "$answer" == "y" ]]; then
		echo "You didn't have a choice anyways!"; sleep 1
		remove_nano $package
	else
		echo "Invalid option."
	fi
}

remove_nano() {
	dnf remove $package -y &> /dev/null
	echo "Boom! System is clean!"
	echo ""
	echo "==========================="
	echo "NANO HAS BEEN REMOVED!!!"
	echo "==========================="
	return 0
}

check
prompt
exit 0
