#!/bin/bash
##############
# This script will run Software updates and will check if the updates need to reboot or not. 
#
# This script is meant to be used while a user is logged in. It will allow the user to not do the software updates 98 times. 
# The 99th time the user does not get a choice about installing the updates. They will just install and display a warning message. 
#
# This was writen by
# Kyle Brockman
# While working for Univeristy Information Technology Servives
# at the Univeristy of Wisconsin Milwaukee
##############

CD="/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog"
CDI="/Applications/Utilities/CocoaDialog.app/Contents/Resources"

if [ -f /var/db/.uitsLiveSoftwareUpdate ]; then
	echo "file is here"
else
	echo "0" > /var/db/.uitsLiveSoftwareUpdate
	echo "made the file"
fi

U=`who |grep console| awk '{print $1}'`
echo $U

if [[ $U == "" ]]; then
	echo "NO one logged in"
	echo "Installing updates..."
	/usr/sbin/jamf policy -trigger livesoftwareupdate
	echo "Updates have been installed at the login window"
	exit 0
fi


FILECOUNT=`cat /var/db/.uitsLiveSoftwareUpdate`

LEFT=$((42 - $FILECOUNT))

/usr/sbin/softwareupdate -l | grep "restart"

if [[ `/bin/echo "$?"` == 1 ]] ; then #updates with no reboot
	if [ $FILECOUNT == "42" ]; then
			echo "forcing update after 42 NOs"
			
			$CD ok-msgbox --no-cancel --icon-file --icon-file $CDI/gear.icns --float  --title "Software Updates " --text "Software updates are being applied." --informative-text "You have clicked No $FILECOUNT Times. Please do not shutdown, close the lid, or reboot your computer now. This could damage your computer and require a rebuild with DATA LOSS!!"
			
			echo "Installing updates..."
			/usr/sbin/jamf policy -trigger livesoftwareupdate
			sleep 30
			echo "0" > /var/db/.uitsLiveSoftwareUpdate
			cat /var/db/.uitsLiveSoftwareUpdate

			$CD bubble --icon-file $CDI/gear.icns --background-top "00cb24" --background-bottom "aefe95" --timeout 600 --title "Software Updates" --text "Software updates have been installed. You can now sleep, shutdown, or use your computer as normal."
			
		else

			FIRST=`$CD yesno-msgbox --no-cancel --string-output --icon-file $CDI/gear.icns --string-output --title "Software Updates are Available" --text "Your Computer has software updates available." --informative-text "   Would you like to install updates now?
			   You have clicked No $FILECOUNT times, you can click No $LEFT more times."`
	
		if [ "$FIRST" == "Yes" ]; then
			echo "Uesr clicked yes"
			echo "Installing all updates"
			/usr/sbin/jamf policy -trigger livesoftwareupdate
			Sleep 30
			echo "0" > /var/db/.uitsLiveSoftwareUpdate
			cat /var/db/.uitsLiveSoftwareUpdate

			$CD bubble --icon-file $CDI/gear.icns --background-top "00cb24" --background-bottom "aefe95" --timeout 600 --title "Software Updates" --text "Software updates have been installed. You can now sleep, shutdown, or use your computer as normal."

		else
	
			echo "User clicked no"
			NUM=$(($FILECOUNT + 1))
			echo $NUM > /var/db/.uitsLiveSoftwareUpdate
			echo $NUM
			exit 1
	
		fi
	fi 
#####	
else #updates with reboot
#####	
	if [ $FILECOUNT == "42" ]; then
			echo "forcing update after 42 NOs"

			$CD ok-msgbox --no-cancel --icon-file --icon-file $CDI/gear.icns --float  --title "Software Updates" --text "Software updates are being applied!" --informative-text "You have clicked No $FILECOUNT Times. These updates require a reboot. After the updates finish installing you will have 5 minutes to save what your doing and your computer will reboot. Please do not shutdown, close the lid, or reboot your computer now. This could damage your computer and require a rebuild with DATA LOSS!!"
			
			echo "Installing updates..."
			/usr/sbin/jamf policy -trigger livesoftwareupdate
			sleep 30
			echo "0" > /var/db/.uitsLiveSoftwareUpdate
			cat /var/db/.uitsLiveSoftwareUpdate
			
		else
		
FIRST=`$CD yesno-msgbox --no-cancel --string-output --icon-file $CDI/gear.icns --string-output --title "Software Updates are Available" --text "Your Computer has software updates available." --informative-text "These updates require a reboot. After the updates finish installing you will have 5 minutes to save what your doing and the computer will reboot.

   You have clicked No $FILECOUNT times, you can click No $LEFT more times."`
	
		if [ "$FIRST" == "Yes" ]; then
			echo "Uesr clicked yes"
			echo "Installing all updates"
			/usr/sbin/jamf policy -trigger livesoftwareupdate
			echo "0" > /var/db/.uitsLiveSoftwareUpdate
			cat /var/db/.uitsLiveSoftwareUpdate
		else
			echo "User clicked no"
			NUM=$(($FILECOUNT + 1))
			echo $NUM > /var/db/.uitsLiveSoftwareUpdate
			echo $NUM
			exit 1
	
		fi
	fi 
fi

exit 0