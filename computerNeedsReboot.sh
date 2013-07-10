#!/bin/bash

CD="/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog"
CDI="/Applications/Utilities/CocoaDialog.app/Contents/Resources"

if [ -f /var/db/.uitsComputerNeedsReboot ]; then
	echo "file is here"
else
	echo "0" > /var/db/.uitsComputerNeedsReboot
	echo "made the file"
fi

NEED=`cat /var/db/.uitsComputerNeedsReboot`

if [[ NEED = "1" ]]; then
	$CD bubble --icon-file $CDI/gear.icns --background-top "00cb24" --background-bottom "aefe95" --timeout 60 --title "Software Updates" --text "You computer needs a reboot, please do so as soon as possible"
else
	exit 0
fi

exit 0