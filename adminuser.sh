#!/bin/bash

###############################
# UNDER DEVELOPMENT DO NOT USE#
###############################

if [[ $UID -ne 0 ]]; 
then echo "[info] please run as admin"; 
exit 1
fi
#fill these as desired
USERNAME=
REALNAME=""
PASSWORD=""

ADMIN_GROUPS="admin _lpadmin _appserveradm _appserverusr"

#get the highest valued ID and add one
OLDID=$(dscl . -list /Users UniqueID | awk '{print $2}' | sort -ug | tail -1)
ID=$((OLDID + 1))
echo "[info] user $USERNAME will be created with ID: $ID"
#create a new user
dscl . -create /Users/$USERNAME 
dscl . -passwd /Users/$USERNAME "$PASSWORD"
dscl . -create /Users/$USERNAME RealName "$REALNAME"
dscl . -create /Users/$USERNAME UniqueID "$ID"
dscl . -create /Users/$USERNAME PrimaryGroupID 80
dscl . -create /Users/$USERNAME UserShell /usr/bin/bash
dscl . -create /Users/$USERNAME NFSHomeDirectory /User/$USERNAME
echo "[pass] sharing user $USERNAME user created"
#add the user to the admin groups
for GROUP in $ADMIN_GROUPS ; do
    dseditgroup -o edit -t user -a "$USERNAME" "$GROUP"
done 

#-addUser <user name> [-fullName <full name>] 
#[-UID <user ID>] 
#[-password <user password>] 
#[-hint <user hint>] 
#[-home <full path to home>] 
#[-admin] 
#[-picture <full path to user image>]

exit 0