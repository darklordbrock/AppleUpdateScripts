#!/bin/bash

CD="/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog"
CDI="/Applications/Utilities/CocoaDialog.app/Contents/Resources"

if [ -f /var/db/.uitsComputerNeedsReboot ]; then
	echo "file is here"
else
	echo "0" > /var/db/.uitsComputerNeedsReboot
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

/usr/sbin/softwareupdate -l | grep -i "restart"

if [[ `/bin/echo "$?"` == 1 ]] ; then #updates with no reboot
		
	echo "Telling the user that updates are being installed"
	
	$CD bubble --icon-file $CDI/gear.icns --background-top "00cb24" --background-bottom "aefe95" --timeout 60 --title "Software Updates" --text "Updates are currently being installed."
	
	
	/usr/sbin/jamf policy -trigger livesoftwareupdate
		
	echo "Updates have been installed and told the user they are complete"	
	
	$CD bubble --icon-file $CDI/gear.icns --background-top "00cb24" --background-bottom "aefe95" --timeout 60 --title "Software Updates" --text "Updates have been installed. You can use your computer as normal."
	
#####	
else #updates with reboot
#####	
	
	/usr/sbin/softwareupdate -l | grep -i "firmware"
	
	if [[ `/bin/echo "$?"` == 1 ]]; then
		
		echo "Telling the user that updates are being installed"
	
		$CD bubble --icon-file $CDI/gear.icns --background-top "00cb24" --background-bottom "aefe95" --timeout 60 --title "Software Updates" --text "Updates are currently being installed."


		/usr/sbin/jamf policy -trigger livesoftwareupdate
		echo "1" > /var/db/.uitsComputerNeedsReboot
	
		echo "Updates have been installed, told the user they are complete, the computer needs to be rebooted, while plugged into power if a laptop."	
	
		$CD bubble --icon-file $CDI/gear.icns --background-top "00cb24" --background-bottom "aefe95" --timeout 60 --title "Software Updates" --text "Updates have been installed. You computer needs a reboot while plugged into power to complete the updates. Please do so as soon as possible"
		
	#####
	else #updates for firmware
	#####
		
		echo "Telling the user that updates are being installed"
	
		$CD bubble --icon-file $CDI/gear.icns --background-top "00cb24" --background-bottom "aefe95" --timeout 60 --title "Software Updates" --text "Updates are currently being installed."


		/usr/sbin/jamf policy -trigger livesoftwareupdate
		echo "1" > /var/db/.uitsComputerNeedsReboot
	
		echo "Updates have been installed, told the user they are complete, and the computer needs to be rebooted."	
	
		$CD bubble --icon-file $CDI/gear.icns --background-top "00cb24" --background-bottom "aefe95" --timeout 60 --title "Software Updates" --text "Updates have been installed. You computer needs a reboot to complete the updates. Please do so as soon as possible"
		
	fi
	
	
fi
