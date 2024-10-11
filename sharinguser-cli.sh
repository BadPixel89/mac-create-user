#!/bin/bash

if [ $# == 0 ]; then
    echo "usage: sharinguser.sh [-nrp]"
    echo "    -n <string>[required] specify username"
    echo "    -r <string>[optional] specify real name, will match user name if not specified"
    echo "    -p <string>[optional] specify password"
    echo "    -h <string>[optional] specify 1 for hidden account, default is visible"
    exit
fi

if [[ $UID -ne 0 ]]; 
then echo "[info] please run as admin"; 
exit 1
fi

#fill these as desired and remove flag parsing if you need to make the same account every time
USERNAME=
REALNAME=""
PASSWORD=""
HIDDEN="0"

while getopts n:r:p: flag
do
    case "${flag}" in
        n) USERNAME=${OPTARG};;
        r) REALNAME=${OPTARG};;
        p) PASSWORD=${OPTARG};;
        h) HIDDEN=${OPTARG};;
        ?) ;; # not sure when these actually run, I couldn't get them to
        *) ;; # so I left them blank
    esac
done

if [ "$USERNAME" == "" ] ; then echo "[info] please set a username"; exit 1; fi
if [ "$REALNAME" == "" ] ; then REALNAME=$USERNAME; fi

if [ "$PASSWORD" == "" ] ; then read -p "[warn] no password set. continue? (y/n)" yn; 
    case $yn in 
        y) echo "[info] continuing without password";;
        n) echo "[info] please re-run with the -p flag specified";
        exit 0;;
        *)
        exit 0;;
    esac
fi

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
dscl . -create /Users/$USERNAME IsHidden "$HIDDEN"
echo "[pass] sharing user $USERNAME user created with ID: $ID"
exit 0
