#!/bin/bash

# Root Verification
if [ "$(id -u)" -ne 0 ]; then
	echo "User must be ROOT to run this script." >&2
	exit 1
fi

# Menu
display_menu() {
	echo "Select an option:"
	echo "1) Compress a file"
	echo "2) Decompress a file"
	echo "3) Archive a file"
	echo "4) Un-archive a file"
	echo "5) Set file permissions"
	echo "6) Change file ownership"
	echo "7) Exit"
}

# File Compression
compress_file() {
	read -p "Enter the path to the file you want to compress: " compress
	gzip "$compress" && echo "File compressed successfully."
}

# File De-Compression
decompress_file() {
	read -p "Enter the path to the file you want to de-compress: " decompress
	gzip -d "$decompress" && echo "File decompressed successfully."
}

# File Archive
archive_file() {
	read -p "Enter the path to the file you wish to archive: " archive
	tar -cvf "$archive.tar" "$archive" && echo "File archived successful!"
}

# File Un-Archive
unarchive_file() {
	read -p "Enter the path to the file you wish to un-archive: " unarchive
	tar -xvf "$unarchive" && echo "File un-archived successfully."
}

# Set File Permissions
set_perm() {
	read -p "Enter the path to file you wish to modify: " file
	read -p "Enter the permissions (in octal format, e.g., 755): " permission
	chmod "$permission" "$file" && echo "File permission changed successfully." && ls -l $file
}

# Change Ownership
change_ownership() {
	read -p "Enter the path to file you wish to change ownership for: " file2
	read -p "Enter the new owner username: " owner_username
	chown "$owner_username" "$file2" && echo "Ownership changed successfully." && ls -l "$file1"
}

# Loop
while true; do
	display_menu
	read -p "Enter your choice (1-7): " choice
	case $choice in
		1) compress_file ;;
		2) decompress_file ;;
		3) archive_file ;;
		4) unarchive_file ;;
		5) set_perm ;;
		6) change_ownership ;;
		7) echo "Exiting..."; break ;;
		*) echo "Invalid Option. Please enter a number between 1-7."
	esac
done
		






