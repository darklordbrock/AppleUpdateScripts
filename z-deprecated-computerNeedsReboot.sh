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

echo "Need = " $NEED

if [[ NEED = "1" ]]; then
	echo "Computer does need to be rebooted"
	$CD bubble --icon-file $CDI/gear.icns --background-top "00cb24" --background-bottom "aefe95" --timeout 60 --title "Software Updates" --text "You computer needs a reboot, please do so as soon as possible"
else
	echo "Computer does not need to be rebooted"
	exit 0
fi

exit 0