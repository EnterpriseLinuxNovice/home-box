#!/usr/bin/env bash

# Required packages in array
pre_packages=("httpd" "httpd-tools" "php" "gcc" "glibc" "glibc-common" "gd" "gd-devel" "make net-snmp")
# Array to store results
results=()
# Home Directory
nag_home=$(/root/nagios)
# Nagios tar location
nag_core=$(https://assets.nagios.com/downloads/nagioscore/releases/nagios-4.4.9.tar.gz)
nag_plug=$(https://nagios-plugins.org/download/nagios-plugins-2.3.3.tar.gz)


check_packages() {
	for list in ${pre_packages[@]}; do
		if rpm -q "$list" &> /dev/null; then
			results+=("$list: Installed")
		else
			results+=("$list: NOT Installed")
			install_package "$list"
		fi
	done

	for results in "${results[@]}"; do
		echo "$results"
	done
}

install_package() {
	echo "Installing $list..."; yum install -y "$list"
	return
}

check_user() {
	grep nagios /etc/passwd &> /dev/null
	if [[ "$?" == "0" ]]; then
		echo "nagios exists."
	else
		echo "nagios doesn't exist."
		echo "Adding user..."; useradd nagios &> /dev/null && echo "Nagios has been added."
	fi
}

check_group() {
        grep nagcmd /etc/group &> /dev/null
        if [[ "$?" == "0" ]]; then
                echo "nagcmd group exists."
        else
                echo "nagcmd group doesn't exist."
                echo "Adding group..."; groupadd nagcmd &> /dev/null && echo "Nagcmd has been added."
        fi
}

groupmod() {
	usermod -G nagcmd nagios &>/dev/null
	usermod -G nagcmd apache &>/dev/null
}

make_dir() {
	if [[ -e "$nag_home" ]]; then
		echo "Directory exists."
	else
		echo "Directory doesn't exists."
		echo "Creating directory..."; mkdir "$nag_home" &> /dev/null
	fi
}

get_nagios_package() {
	cd "$nag_home"; wget "$nag_core" &> /dev/null; wget "$nag_plugs" &> /dev/null
}

untar() {
					<---------------------------------------------------- LEFT OFF HERE		
}

check_packages
check_user
check_group
groupmod
make_dir
get_nagios_package
untar


