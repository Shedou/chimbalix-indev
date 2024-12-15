#!/usr/bin/env bash
# Script version 1.0

User_Home_Dir=~

FilesToRemove=(
"$User_Home_Dir/.config/menus/applications-merged/Example.menu"
"$User_Home_Dir/.local/share/applications/apps/Example/"
"$User_Home_Dir/.local/share/desktop-directories/apps/Example/"
"$User_Home_Dir/portsoft/other/Example/"
)

function _remove {
	local entry="$1"
	if [ -e "$entry" ]; then
		echo -e "Removing:\n $entry"
		rm -rf "$entry"
	else
		echo -e "Object not found, skip:\n $entry"
	fi
}

echo -e "\
Uninstaller of the \"Example\" application.

Files and directories that will be deleted:
$(for i in "${!FilesToRemove[@]}"; do echo "${FilesToRemove[$i]}"; done)

Do you want to remove the \"Example\" application? Enter \"y\" or \"yes\" to continue.
"

read accept_or_no

if [ "$accept_or_no" == "y" ] || [ "$accept_or_no" == "yes" ]; then
	for i in "${!FilesToRemove[@]}"; do _remove "${FilesToRemove[$i]}"; done
	xfce4-panel -r # Update Menu
else
	echo "Abort."
fi

echo -e "\nPause..."
read pause
