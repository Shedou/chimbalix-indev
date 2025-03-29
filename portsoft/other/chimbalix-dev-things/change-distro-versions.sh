#!/usr/bin/env bash
# Script version 1.0

# -= Examples =-
# Path_To_Script="$( dirname "$(readlink -f "$0")")"
# Current User Name: $USER
# Pause: read pause
# Pause (press any key to exit): read -rn1

# FileNameWithoutExtension="${FileName%.*}"
# FileNameWithoutPath="$(basename $FileName)"
# FilePathWithoutFileName="$(dirname $FileNameWithPath)"
# Remove 2 first and 1 last char from String: "${String:2:-1}"
#
# sed -i -e "s~TEXT_TO_REPLACE~TEXT~g" "File.txt"
# sed -i "s~ADD_TEXT_BEFORE_CURRENT_LINE~&\nADDED_TEXT~" "File.txt"
# grep -rl "FIND_AND_REPLACE_THIS_TEXT" "Path_To_Dir_With_Files" | xargs sed -i "s~FIND_AND_REPLACE_THIS_TEXT~NEW_TEXT~g" &> /dev/null

# Add all arguments to variable: Files="$@"
# Remove the first argument from the queue: shift
# get error code from last command: "$?"

# Array arguments iterate:
# Files=("$@")
# for i in "${!Files[@]}"; do
#	CurrentFile="${Files[$i]}"
# 	Current_Array_Number="$i"
# done

# Font styles
# Usage: "${B}Bold Text${N}"
# B=$(tput bold)
# N=$(tput sgr0)

OLDSTRING="24.6"
NEWSTRING="24.7"

sudo sed -i -e "s~$OLDSTRING~$NEWSTRING~g" "/etc/initrd_release"
sudo sed -i -e "s~$OLDSTRING~$NEWSTRING~g" "/etc/live/version/initrd_release"

sudo sed -i -e "s~$OLDSTRING~$NEWSTRING~g" "/etc/live/version/antiX"
sudo sed -i -e "s~$OLDSTRING~$NEWSTRING~g" "/etc/os-release"
sudo sed -i -e "s~$OLDSTRING~$NEWSTRING~g" "/usr/lib/os-release"

sudo sed -i -e "s~$OLDSTRING~$NEWSTRING~g" "/usr/local/share/live-files/files/etc/lsb-release"
sudo sed -i -e "s~$OLDSTRING~$NEWSTRING~g" "/etc/lsb-release"
