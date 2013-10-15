#!/bin/bash


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
	/usr/sbin/jamf policy -trigger UITScomputerNeedsReboot
else
	echo "Computer does not need to be rebooted"
	exit 0
fi

exit 0