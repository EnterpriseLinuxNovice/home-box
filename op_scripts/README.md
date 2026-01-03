# ====== op_scripts ======

These scripts are adhoc bash scripts I have created to tackle specific issues 
I have encounteredand is **__NOT DESIGNED TO BE IDEMPOTENT__**.

__Download scripts steps:__          
`git clone https://github.com/EnterpriseLinuxNovice/home-box.git`
`chmod u+x *.sh`

### ------ AddADAccount ------

This script was made for RHEL systems using SSS Daemon for authentication with Active Directory.

### ------ docker_install ------

Removes any old docker instances and does a clean install of docker engine by pulling from source.

### ------ hostname_change ------

Rename's hostname by modifying `/etc/hosts` and `/etc/hostname`.

### ------ lvm2 ------

Create, remove, or modify Logical Volumes on system. 

Requirements:
- Will need to know disk name, (i.e., /dev/sdX).
- If extending, you will need to know Volume Group and Logical Volume names. You may use `vgs|vgdisplay` and `lvs|lvdisplay`.
- Must have `lvm2` package installed.

### ------ reset_config ------

This script will set up AWS CLI credentials by creating/modifying `.aws/config` and `.aws/credentials`.

**IMPORTANT:** By design, this script will store credentials in plain-text therefore, this script is unsecured by design.

