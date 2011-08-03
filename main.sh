#!/bin/bash
# Proper header for a Bash script.

# Check for root user login
if [ ! $( id -u ) -eq 0 ]; then
	echo "You must be root to run this script."
	echo "Please enter su before running this script again."
	exit 2
fi

IS_CHROOT=0 # changed to 1 if and only if in chroot mode
USERNAME=""
DIR_DEVELOP=""

# The remastering process uses chroot mode.
# Check to see if this script is operating in chroot mode.
# /srv directory only exists in chroot mode
if [-d "/srv"]; then
	IS_CHROOT=1 # in chroot mode
	DIR_DEVELOP=/usr/local/bin/develop 
else
	USERNAME=$(logname) # not in chroot mode
	DIR_DEVELOP=/home/$USERNAME/develop 
fi

# Replacing files in /usr/local/bin and /usr/share/antiX/localisation/en/local-bin
# Remove the idesk, Fluxbox, and Nitrogen configuration options 
# (due to the removal of these packages)
# antiX Control Center -> Swift Linux Control Center

echo "REPLACING THE CONTROL CENTER"
rm /usr/local/bin/antixcc.sh
cp $DIR_DEVELOP/control_center/usr_local_bin/antixcc.sh /usr/local/bin
chown root:root /usr/local/bin/antixcc.sh
chmod a+x /usr/local/bin/antixcc.sh

rm /usr/share/antiX/localisation/en/local-bin/antixcc.sh
cp $DIR_DEVELOP/control_center/usr_local_bin/antixcc.sh /usr/share/antiX/localisation/en/local-bin
chown root:root /usr/share/antiX/localisation/en/local-bin/antixcc.sh
chmod a+x /usr/share/antiX/localisation/en/local-bin/antixcc.sh

if [ $IS_CHROOT -eq 0 ]; then
	chown $USERNAME:users /usr/share/antiX/localisation/en/local-bin/antixcc.sh
else
	chown demo:users /usr/share/antiX/localisation/en/local-bin/antixcc.sh
fi

exit 0
