#!/bin/bash

CD="/Applications/Utilities/CocoaDialog.app/Contents/MacOS/CocoaDialog"
CDI="/Applications/Utilities/CocoaDialog.app/Contents/Resources"

$CD bubble --icon-file $CDI/gear.icns --background-top "00cb24" --background-bottom "aefe95" --timeout 60 --title "Software Updates" --text "You computer needs a reboot, please do so as soon as possible"

exit 0