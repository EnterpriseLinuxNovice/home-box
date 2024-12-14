# bash
Some bash scripts that automate my day-to-day statement of work.

IMPORTANT: These series of scripts was made with ONLY Red Hat distributions (RHEL 7, 8, 9, CentOS 8, CentOS 9, and Fedora) in mind. This script may or may not execute properly on other distributions. Do not execute if you are unsure of your system's configuration.


'lvm2.sh' overview:

	- NOTE: This script is UNFINISHED. This script was originally made to JUST add a whole new logical volume/mountpoint to a linux system using Logical Volume Manager for storage and filesystem setup. The other features shown in this script, including "expanding logical volume size", "reducing logical volume size", and "deleting a logical volume", are unfinished are are currently being worked on.
	- What does it do:
			1) Create a new logical volume/mountpoint and adds entry to /etc/fstab for persistent mount.
			2) Expand an existing LV size. (Unfinished).
			3) Reduce an existing LV size. (Unfinished).
			4) Delete a LV. (Unfinished).

