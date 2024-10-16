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
dscl . -create /Users/$USERNAME PrimaryGroupID 20 #80 is admin but should be 20 (staff) and rely on adding below
dscl . -create /Users/$USERNAME UserShell /usr/bin/bash
dscl . -create /Users/$USERNAME NFSHomeDirectory /User/$USERNAME

echo "[pass] admin user $USERNAME created"
#add the user to the admin groups
echo "[info] adding user $USERNAME to admin groups"
for GROUP in $ADMIN_GROUPS ; do
    dseditgroup -o edit -t user -a "$USERNAME" "$GROUP"
    echo "[pass] $USERNAME added to $GROUP"
done 

echo "[pass] $USERNAME created and added to admin groups"

# might be needed below to actually add the gome dir correctly
#-addUser <user name> [-fullName <full name>] 
#[-UID <user ID>] 
#[-password <user password>] 
#[-hint <user hint>] 
#[-home <full path to home>] 
#[-admin] 
#[-picture <full path to user image>]

#dscl . -delete "/SharePoints/$USERNAME's Public Folder" # Removes the public folder sharepoint for the local admin?

exit 0