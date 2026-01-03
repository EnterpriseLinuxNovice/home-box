# op_scripts #

These scripts are adhoc bash scripts I have created to tackle specific issues 
I have encounteredand is **__NOT DESIGNED TO BE IDEMPOTENT__**.

In 
## AddADAccount ##

This script was made for RHEL systems using SSS Daemon for authentication with Active Directory.

**Variables**
|Variable|Description|
|$answer, $options, $user_add, $user_del, $user_del| These variables are assigned when executing script in runtime manually by user.|