#!/bin/bash 
#Author: New Wavex86 
#Date Created: Wed Feb 24 21:19:47
#Automatically mounts the usb on a rpi upon startup

DRIVE_CHECK=0 #Counter for loop

#CHeck if root, has to be to write to fstab
if [ $EUID -eq 0 ];
then
	echo "You are root!, running script"

else
	echo "Not Root!, rerun as root"
	echo "Exiting"
	exit 1

fi

#Print out existing drives for user
lsblk

#Way to check user input
while [ $DRIVE_CHECK -eq 0 ];
do
        echo "Examle: /dev/sda1" 
	read -p "Please enter the full drive path in the dev folder: " DEV

        if [[ "$DEV" =~ [$/] ]];
	then
		echo "Don't add a / at end of path, restarting"
	
	else
		DRIVE_CHECK=1
	fi
done
	   

#Get UID from device name
UUID=$( blkid $DEV | cut -d '"' -f 4 )

#Append device to fstab
echo "UUID=${UUID} /media auto nosuid,nodev,nofail 0 0" >>  /etc/fstab

echo "All done!"

exit 0 
