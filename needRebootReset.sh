#!/bin/bash

if [ -f /var/db/.uitsComputerNeedsReboot ]; then
	echo "file is here"
	echo "0" > /var/db/.uitsComputerNeedsReboot
else
	echo "0" > /var/db/.uitsComputerNeedsReboot
	echo "made the file"
fi

exit 0