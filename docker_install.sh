#!/usr/bin/env bash

# Verify root
if [[ "$UID" -ne 0 ]]; then
	echo "You must execute this script with super user privileage!"
	exit
fi

uninstall_old() {
	echo "Uninstalling any old version of docker..."
	dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-engine &>/dev/null
	echo "Old Docker versions uninstalled (if any)."
}

repo_setup() {
	dnf install -y dnf-plugins-core &>/dev/null
	dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo &>/dev/null
}

install_engine() {
	dnf -y --nogpgcheck install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &>/dev/null
}
	
start_docker() {
	systemctl enable --now docker &>/dev/null
	systemctl status docker
}

verify_install() {
	docker run hello-world &>/dev/null
	if [[ $? -eq 0 ]]; then
		echo "Docker installed successfully!"
	else
		echo "Docker install failed!"
	fi
}

# Main script
uninstall_old
repo_setup
install_engine
start_docker
verify_install

