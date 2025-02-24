#!/usr/bin/env bash
# WARNING! Works only with sudo / root privilegies!
# crutch for linux
# LICENSE at the end of this file!

# If not in Live mode:
if [ ! -d /live ]; then
	PortSoftPresent=false
	
	if [ -e "$HOME/.config/user-dirs.dirs" ]; then source "$HOME/.config/user-dirs.dirs"
	else exit; fi
	
	Desktop_Dir="$XDG_DESKTOP_DIR"
	
	AutostartFile="$HOME/.config/autostart/crutch-for-linux.desktop"
	echo "Post-installation script!"
	echo "Don't skip!"
	
	# Remove installer shortcut
	if [ -f "$Desktop_Dir/cinstall.desktop" ]; then rm "$Desktop_Dir/cinstall.desktop"; fi
	
	# Check "portsoft" directory:
	if [ -d /portsoft ]; then PortSoftPresent=true
	else echo "The portsoft (Program Files) directory was not found, please do not use this script on other Linux distributions..."
	fi
	
	if [ $PortSoftPresent == true ]; then
		# Add bookmarks
		echo "Preparing Bookmarks for File Manager..."
		sed -i -e "s~USERNAME~$USER~g" "$HOME/.config/gtk-3.0/bookmarks"
		
		# Make desktop files trusted:
		echo "Make Desktop files trusted..."
		find "$Desktop_Dir/" -iname '*.desktop' -print0 | while read -d $'\0' -r file ; do
			"/portsoft/script/chimbalix-scripts/context-menu/tools/gio-trust.sh" -trust --silent "$file"
		done
		
		# Preparing Wine Prefix:
		"/portsoft/other/chimbalix-wine-prefix/install.sh"
		
		# Disable "Autorun" file:
		if [ -f "$AutostartFile" ]; then sed -i -e "s~Hidden=false~Hidden=true~g" "$AutostartFile"; fi
	fi
else
	# Add bookmarks
	sed -i -e "s~USERNAME~$USER~g" "/home/demo/.config/gtk-3.0/bookmarks"
	# Make desktop files trusted:
	find "/home/demo/Desktop/" -iname '*.desktop' -print0 | while read -d $'\0' -r file ; do
		"/portsoft/script/chimbalix-scripts/context-menu/tools/gio-trust.sh" -trust --silent "$file"
	done
	exit 0;
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
