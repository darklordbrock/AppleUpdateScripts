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

if [ -f /var/db/.uitsLiveSoftwareUpdate ]; then
	echo "file is here"
else
	echo "0" > /var/db/.uitsLiveSoftwareUpdate
	echo "made the file"
fi

FILECOUNT=`cat /var/db/.uitsLiveSoftwareUpdate`

LEFT=$((42 - $FILECOUNT))

/usr/sbin/softwareupdate -l | grep "restart"

if [[ `/bin/echo "$?"` == 1 ]] ; then #updates with no reboot
	if [ $FILECOUNT == "42" ]; then
			echo "forcing update after 42 NOs"
	
			/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -icon /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/Resources/Message.png -heading "Software Updates" -description "You have clicked No $FILECOUNT Times and Software updates are being applied. Please do not shutdown, close the lid, or reboot your computer now. This could damage your computer and require a rebuild with DATA LOSS!!"
			
			echo "Installing updates..."
			#/usr/sbin/jamf policy -trigger livesoftwareupdate
			sleep 30
			echo "0" > /var/db/.uitsLiveSoftwareUpdate
			cat /var/db/.uitsLiveSoftwareUpdate

			/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -icon /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/Resources/Message.png -heading "Software Updates" -description "Software updates have been installed. You can now sleep, shutdown, or use your computer as normal."

		else

		FIRST=`/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -icon /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/Resources/Message.png -heading "Software Updates are Available" -description "Your Computer has software updates available. You have clicked No $FILECOUNT Times. You can click No $LEFT times. Would you like to install updates?" -button1 "Yes" -button2 "Cancel" -cancelButton "2"`
	
		if [ "$FIRST" == "0" ]; then
			echo "Uesr clicked yes"
			echo "Installing all updates"
			#/usr/sbin/jamf policy -trigger livesoftwareupdate
			Sleep 30
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
#####	
else #updates with reboot
#####	
	if [ $FILECOUNT == "42" ]; then
			echo "forcing update after 42 NOs"
/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -icon /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/Resources/Message.png -heading "Software Updates" -description "You have clicked No $FILECOUNT Times and Software updates are being applied. These updates require a reboot. After the updates finish installing you will have 5 minutes to save what your doing and the computer will reboot. Please do not shutdown, close the lid, or reboot your computer now. This could damage your computer and require a rebuild with DATA LOSS!!"

			echo "Installing updates..."
			#/usr/sbin/jamf policy -trigger livesoftwareupdate
			sleep 30
			echo "0" > /var/db/.uitsLiveSoftwareUpdate
			cat /var/db/.uitsLiveSoftwareUpdate
			
		else
		
		FIRST=`/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -icon /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/Resources/Message.png -heading "Software Updates are Available" -description "Your Computer has software updates available. These updates require a reboot. After the updates finish installing you will have 5 minutes to save what your doing and the computer will reboot. You have clicked No $FILECOUNT Times. You can click No $LEFT times. Would you like to install updates?" -button1 "Yes" -button2 "Cancel" -cancelButton "2"`

	
		if [ "$FIRST" == "0" ]; then
			echo "Uesr clicked yes first time"
			echo "Installing all updates"
			#/usr/sbin/jamf policy -trigger livesoftwareupdate
			echo "0" > /var/db/.uitsLiveSoftwareUpdate
			cat /var/db/.uitsLiveSoftwareUpdate
		else
			echo "User clicked no first time"
			NUM=$(($FILECOUNT + 1))
			echo $NUM > /var/db/.uitsLiveSoftwareUpdate
			echo $NUM
			exit 1
	
		fi
	fi 
fi

exit 0