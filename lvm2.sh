#!/usr/bin/env bash
#Root Privileges
if [ "$EUID" -ne 0 ]; then
	    echo "You must be ROOT in order to execute this script."
	        exit 1
fi
# ASCII Banner
cat << "EOF"
###################################################
#       _      __      __   __    __              #
#      | |     \ \    / /  |  \  /  |             #
#      | |      \ \  / /   |   \/   |             # 
#      | |       \ \/ /    |        |             #
#      | |____    \  /     |  |\/|  |             #
#      |______|    \/      |__|  |__|             #
#                                    T-O-O-L      #
#                                                 #
#                                                 #
# by: Joey                                        #
###################################################
#              !!!IMPORTANT!!!                    #
#    This script was made with ONLY Red Hat       #
#    distributions in mind. This script may       #
#    or may not execute properly on other         #
#    distributions. Do not execute if you         #
#    are unsure of your system's configuration.   #
#                                                 # 
#    BE CAUTIOUS WHEN USING SCRIPTS ON THE        #
#       	  INTERNET!!!			  #	
###################################################
EOF

create_mountpoint() {
	clear
	read -p "Enter Physical Volume name (e.g., /dev/sdX): " pv_name
	read -p "Enter Volume Group name (e.g., Data_VG): " vg_name
	read -p "Enter Logical Volume name (e.g., Data_LV): " lv_name
	read -p "Enter Logical Volume size (GB): " lv_size
	read -p "Enter Mount Point (e.g., /data): " mount
	read -p "Enter filesystem type (ext4/xfs): " fs_type
    # Check if PV exists
	if pvs --noheadings -o pv_name | grep -qw "$pv_name"; then
		echo "Physical Volume already EXISTS!"
		return 1
	fi
    # Check if VG exists
    	if vgs --noheadings -o vg_name | grep -qw "$vg_name"; then
        	echo "Volume Group already EXISTS!"
        	return 1
    	fi
    # Check if LV exists
    	if lvs --noheadings -o lv_name | grep -qw "$lv_name"; then
        	echo "Logical Volume already EXISTS!"
        	return 1
    	fi
    # Create PV
    	pvcreate "$pv_name" &>/dev/null || { echo "Failed to create Physical Volume."; return 1; }
    # Create VG
    	vgcreate "$vg_name" "$pv_name" &>/dev/null || { echo "Failed to create Volume Group."; return 1; }
    # Create LV
    	lvcreate -n "$lv_name" -L "${lv_size}G" "$vg_name" &>/dev/null || { echo "Failed to create Logical Volume."; return 1; }
    # Format LV with filesystem
    	if [[ "$fs_type" == "ext4" ]]; then
        	mkfs.ext4 "/dev/$vg_name/$lv_name" &>/dev/null || { echo "Failed to format with EXT4."; return 1; }
    	elif [[ "$fs_type" == "xfs" ]]; then
        	mkfs.xfs "/dev/$vg_name/$lv_name" &>/dev/null || { echo "Failed to format with XFS."; return 1; }
    	else
        	echo "Error: Filesystem MUST be either XFS or EXT4!"
        	return 1
    	fi
    # Create mountpoint if it doesn't exist
    	if [[ ! -d "$mount" ]]; then
        	mkdir -p "$mount"
    	fi
    # Add to fstab
    	echo "/dev/$vg_name/$lv_name $mount $fs_type defaults 0 0" >> /etc/fstab
    # Mount the logical volume
    	mount "/dev/$vg_name/$lv_name" "$mount" || { echo "Failed to mount the Logical Volume."; return 1; }
    	echo "Logical Volume successfully created and mounted at $mount!"
}

expand_mountpoint() {
    echo "Feature not yet implemented."
}

decrease_mountpoint() {
    echo "Feature not yet implemented."
}

delete_mountpoint() {
    echo "Feature not yet implemented."
}

main_menu() {
    while true; do
        echo "Please select a configuration option below:"
        echo "1. Create a new logical Volume."
        echo "2. Expand an existing logical volume."
        echo "3. Decrease an existing logical volume."
        echo "4. Delete a logical volume."
        echo "5. Exit."

        read -p "Enter your choice: " menu_choice

        case $menu_choice in
            1)
                create_mountpoint
                ;;
            2)
                expand_mountpoint
                ;;
            3)
                decrease_mountpoint
                ;;
            4)
                delete_mountpoint
                ;;
            5)
                echo "Exiting program."
                exit 0
                ;;
            *)
                echo "Invalid Option. Please select a valid option."
                ;;
        esac
    done
}

# Entrance Prompt
echo "This tool will make major configuration changes to critical system files, such as /etc/fstab. If you are unfamiliar with configuring LVM, abort now."
read -p "Do you wish to continue? [Yes/No]: " answer
clear
case "${answer,,}" in
    yes | y)
        echo "Proceeding...."
        main_menu
        ;;
    no | n)
        echo "Aborting process."
        exit 1
        ;;
    *)
        echo "Invalid Input. Respond with 'Yes' or 'No'."
        exit 1
        ;;
esac

