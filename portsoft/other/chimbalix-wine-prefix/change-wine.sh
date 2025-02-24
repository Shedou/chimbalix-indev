#!/usr/bin/env bash
# Script version 1.0
# LICENSE at the end of this file!
#set -x #(for debug info)

ScriptDir="$( dirname "$(readlink -f "$0")")"

LinkVar="$(readlink "/opt/wine-staging")"
echo "$LinkVar"
if [ "$1" == "SetWineStaging" ]; then
	# Check symlink
	if [ "$LinkVar" == "/opt/wine-staging-900" ]; then
		echo -e " Wine Staging 9.0.0 is already in use...\n Abort."
		read pause
		exit 1
	fi
	
	echo -e "
 Switch version to Wine Staging 9.0.
 
 WARNING! Switching Wine version may break existing prefixes! Use with caution!
 Root rights required!
 
 Wine Proton LG 9.5.1 is based on Wine 9.0, so theoretically prefixes
 are compatible between Wine Staging 9.0 and Wine Proton LG 9.5.1,
 but this has not been thoroughly tested.
 
 It is recommended to recreate the prefix when changing the Wine version.
 
 Enter \"y\" or \"yes\" to continue."

	read confirm_stage
	if [ "$confirm_stage" == "y" ] || [ "$confirm_stage" == "yes" ]; then
		sudo rm "/opt/wine-staging"
		sudo ln -s "/opt/wine-staging-900" "/opt/wine-staging"
		
		if [ -e "/opt/wine/gecko/wine-gecko-2.47.4-x86.msi" ]; then
			echo -e " Installing Wine Gecko 2.47.4 x86"
			wine "/opt/wine/gecko/wine-gecko-2.47.4-x86.msi"
		fi
		if [ -e "/opt/wine/gecko/wine-gecko-2.47.4-x86_64.msi" ]; then
			echo -e " Installing Wine Gecko 2.47.4 x86_64"
			wine "/opt/wine/gecko/wine-gecko-2.47.4-x86_64.msi"
		fi
	else
		echo -e "\nAbort"
		read pause
		exit 1;
	fi
fi

###########################################3

if [ "$1" == "SetWineProton" ]; then
	# Check symlink
	if [ "$LinkVar" == "/opt/wine-proton" ]; then
		echo -e " Wine Proton LG 9.5.1 is already in use...\n Abort."
		read pause
		exit 1
	fi

	echo -e "
 Switch version to Wine Proton LG 9.5.1.
 
 WARNING! Switching Wine version may break existing prefixes! Use with caution!
 Root rights required!
 
 Wine Proton LG 9.5.1 is based on Wine 9.0, so theoretically prefixes
 are compatible between Wine Staging 9.0 and Wine Proton LG 9.5.1,
 but this has not been thoroughly tested.
 
 It is recommended to recreate the prefix when changing the Wine version.
 
 Enter \"y\" or \"yes\" to continue."
 
	read confirm_stage_p
	if [ "$confirm_stage_p" == "y" ] || [ "$confirm_stage_p" == "yes" ]; then
		sudo rm "/opt/wine-staging"
		sudo ln -s "/opt/wine-proton" "/opt/wine-staging"
	else
		echo -e "\nAbort"
		read pause
		exit 1;
	fi
fi

echo " Complete."
read pause

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
