#!/bin/bash
##############
#
# This script will install updates from Apple. If the update needs a reboot
# jamf helper will put up a dialog the client can not close until the
# machine is rebooted. 
#
# This was writen by
# Kyle Brockman
# While working for Univeristy Information Technology Servives
# at the Univeristy of Wisconsin Milwaukee
##############

/usr/sbin/softwareupdate -i -a | grep restart

if command ; then

  echo "Computer does not need to be restarted."

else

  U=`who |grep console| awk '{print $1}'`

  echo "User is $U"

  if [[ $U == "" ]]; then
    echo "No user logged in. Restarting..."
    /sbin/reboot
    exit 0
  fi

  echo "Computer needs to be restarted ..."
  /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Software Update" -heading "Restart Required" -description "Software updates require that you restart your computer. Please do so as soon as possible. Restarting will close this box." -alignHeading center -icon /System/Library/CoreServices/Software\ Update.app/Contents/Resources/SoftwareUpdate.icns -iconSize 230 &


fi

exit 0
