#!/bin/bash
#Author: Joey 
#Date: 1/16/2024
#Verify Root Privileges
if [ "$EUID" -ne 0 ]; then
	echo "You must be ROOT in order to execute this script."
	exit 1
fi
#Prompt
echo "#######################################################################################"
echo "Welcome to the LVM Configuration Tool."
echo "This LVM tool allows admins to more efficiently set up LVM on Red Hat-based machines."
echo "#######################################################################################"
#Question
echo "This tool will make major configuration changes to system critical files, such as /etc/fstab, therefore if you are unfamilar with configuring LVM, you should abort now." 
read -p "Do you wish to continue? (Yes/No): " answer
if [ "$answer" == "Yes" ]; then
	echo "#############"
	echo "LVM Editor"
	echo "#############"
	echo 
	read -p "Enter Physical Volume name (i.e., /dev/sdX): " pv_name
	read -p "Enter Volume Group name (i.e., Data_VG): " vg_name
	read -p "Enter Logical Volume name(i.e., Data_LV): " lv_name
	read -p "Enter Logical Volume size (GB): " lv_size
	read -p "Enter Mount Point (/data): " mount
	read -p "Enter filesystem type (ext4/xfs): " fs_type
#Review
#	echo "Review Information:"
#	echo "######################"
#	echo "Physical Volume = $pv_name"
#        echo "Volume Group = $vg_name"
#        echo "Logical Volume $lv_name"
#	echo "Logical Volume size (GB) = $lv_size"
#        echo "Mount Point = $mount"
#        echo  "Filesystem type = $fs_type"
#	echo "######################"
#	read -sn1 -p "Click any key to continue."
#Mountpoint
	if [ -d "$mount" ]; then
		echo "Mountpoint $mount exists. Using $mount as the dedicated mountpoint."
	else
		echo "Mountpoint $mount doesn't exist. Tool will create mountpoint $mount. Standby..."
		mkdir $mount && chmod 750 $mount && sleep 3
#Physical Volume
	if pvdisplay $pv_name; then
		echo "Physical Volume $pv_name detected. Using $pv_name as our dedicated Physical Volume." && sleep 3
	else
		echo "Physical volume $pv_name doesn't exist. Tool will now create and use $pv_name as the dedicated Physical Volume."
		pvcreate $pv_name
	fi
#Volume Group
	if vgdisplay -v $vg_name; then
		echo "Volume Group $vg_name detected. Using $vg_name as our dedicated Volume Group." && sleep 3
        else
                echo "Volume Group $vg_name doesn't exist. Tool will now create and use $vg_name as the dedicated Volume Group."
                vgcreate $vg_name $pv_name
        fi
#Logical Volume
	if lvdisplay -v $lv_name; then
		       echo "Logical Volume $lv_name detected. Using $lv_name as our dedicated Logical Volume." && sleep 3
        else
                echo "Logical Volume $lv_name doesn't exist. Tool will now create and use $lv_name as the dedicated Logical Volume."
                lvcreate -n $lv_name -L $lv_size $vg_name
        fi      
#Filesystem Type
	if [ "$fs_type" == "ext4" ]; then
		echo "Creating Logical Volume /dev/mapper/$vg_name-$lv_name as $fs_type." && sleep 3
		mkfs.$fs_type /dev/mapper/$vg_name-$lv_name && echo "Filesystem format completed SUCESSFULLY."
	elif [ "$fs_type" == "xfs" ]; then
                echo "Creating Logical Volume /dev/mapper/$vg_name-$lv_name as $fs_type." && sleep 3
		mkfs.$fs_type /dev/mapper/$vg_name-$lv_name && echo "Filesystem format completed SUCESSFULLY."
	else
		echo "Please input a valid option."
	fi
#Add to fstab
	echo "/dev/mapper/$vg_name-$lv_name $mount $fs_type defaults 0 0" >> /etc/fstab
	mount -a
	fi
elif [ "$answer" == "No" ]; then
	read -sn1 -p "Click any key to exit LVM Tool."
else
	read -sn1 -p "Invalid Entry. Click any key to exit LVM Tool."
fi	
