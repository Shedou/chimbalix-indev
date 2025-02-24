#!/usr/bin/env bash
# Script version 1.0
# LICENSE at the end of this file!
#set -x #(for debug info)

ScriptDir="$( dirname "$(readlink -f "$0")")"
#AutostartFile="$HOME/.config/autostart/crutch-for-wine.desktop"

Input="$ScriptDir/prefix"
Output="$HOME/.wine"
LinkVar="$(readlink "/opt/wine-staging")"

if [ "$1" == "-reinstall" ]; then
	echo -e "\

 WARNING! 
 Are you sure you want to reinstall the Wine prefix ($Output)?
 ALL PREFIX DATA ($Output) WILL BE DELETED!
 
 Enter \"y\" or \"yes\" to confirm.
"
	read confirm_remove
	if [ "$confirm_remove" == "y" ] || [ "$confirm_remove" == "yes" ]; then
		rm -rf "$Output"
	else
		echo -e "\nAbort"
		read pause
		exit 0;
	fi
fi

if [ ! -d "$Output" ]; then
	echo "Preparing Wine prefix..."
	echo "Please wait!"
	mkdir -p "$Output"
	try=true
	while [ $try == true ]; do
		if wineboot &>/dev/null; then echo "Prefix prepared."; try=false
		else
			echo "\
			Error while preparing prefix. Very slow HDD/Flash?
			Try again..."
			rm -rf "$Output"
		fi
	done
	# Check symlink
	if [ "$LinkVar" == "/opt/wine-staging-900" ]; then
		if [ -e "/opt/wine/gecko/wine-gecko-2.47.4-x86.msi" ]; then
			echo -e " Installing Wine Gecko 2.47.4 x86"
			wine "/opt/wine/gecko/wine-gecko-2.47.4-x86.msi"
		fi
		if [ -e "/opt/wine/gecko/wine-gecko-2.47.4-x86_64.msi" ]; then
			echo -e " Installing Wine Gecko 2.47.4 x86_64"
			wine "/opt/wine/gecko/wine-gecko-2.47.4-x86_64.msi"
		fi
	fi
	echo "Copy new files..."
	cp -rf "$Input/." "$Output"
	wine regedit "$Input/REG_files_dev/fix.reg"
	
	# Remove symlinks
	OLD_IFS=$IFS; IFS=$'\n'
	symlinks=($(find "$Output/drive_c/users/${USER}" -type l))
	IFS=$OLD_IFS
		
	for filenamesym in "${!symlinks[@]}"; do
		CurrentFile="${symlinks[$filenamesym]}"
		rm -f "$CurrentFile"
		mkdir "$CurrentFile"
	done
	
	#if [ -f "$AutostartFile" ]; then
	#	sed -i -e "s~Hidden=false~Hidden=true~g" "$AutostartFile"
	#fi
fi

# MIT License
#
# Copyright (c) 2024 Chimbal
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
