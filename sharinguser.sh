#!/bin/bash

if [[ $UID -ne 0 ]]; 
then echo "[info] please run as admin"; 
exit 1
fi
#fill these as desired
USERNAME=
REALNAME=""
PASSWORD=""

if [ "$USERNAME" == "" ] ; then echo "[info] no username set"; exit 1; fi

#get the highest valued ID and add one
OLDID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
ID=$((OLDID + 1))
echo "[info] user $USERNAME will be created with ID: $ID"
#create a new user
dscl . -create /Users/$USERNAME 
dscl . -passwd /Users/$USERNAME "$PASSWORD"
dscl . -create /Users/$USERNAME RealName "$REALNAME"
dscl . -create /Users/$USERNAME UniqueID "$ID"
dscl . -create /Users/$USERNAME PrimaryGroupID 20
dscl . -create /Users/$USERNAME UserShell /usr/bin/false
dscl . -create /Users/$USERNAME NFSHomeDirectory /dev/null
echo "[pass] sharing user $USERNAME user created"
exit 0