#!/usr/bin/env bash
# Script version 1.0
# LICENSE for this script is at the end of this file
B=$(tput bold)
N=$(tput sgr0)

Codec="$1"; shift; # arg 1
Files=("$@")

#
ffmpeg_exec=ffmpeg
ErrorFiles=""
GoodFiles=""
pause="0"

# CheckName function
function CheckName {
	local FileName="$1"; local OutFileName="$FileName"; local time="$(date +%s)"; local tx="${time:6}"
	if [ -e "$OutFileName" ]; then OutFileName="$FileName-new"; if [ -e "$OutFileName" ]; then OutFileName="$FileName-new-$tx"; fi; fi
	echo "$OutFileName"
}

# PNG
if [ "$Codec" == "png" ]; then
	
	echo -e "Try to execute ffmpeg. \n"
	
	for i in "${!Files[@]}"; do
		CurrentFile="${Files[$i]}"
		OutputFileName="${CurrentFile%.*}"
		FileNameWithoutPath="$(basename $OutputFileName)"
		OutName="$OutputFileName"
		
		# check if the output file exists
		OutName="$(CheckName "$OutName")"
		FileNameWithoutPath="$(basename "$OutName")"
		
		mkdir -p "$OutName"
		Out="$OutName/$FileNameWithoutPath-%03d.png"
		
		if $ffmpeg_exec -i "$CurrentFile" "$Out"; then
			:
		else
			echo "-= WARNING =-"
			echo "Something went wrong..."
			ErrorFiles="${ErrorFiles}\n $OutputFileName.bad.mkv"
			pause="1";
		fi
	done
fi

if [ "$pause" == "1" ]; then
	echo "-= WARNING =-"
	echo "-= List of bad files:"
	echo -e "$ErrorFiles"
	echo -e "\n-= Not enough system memory? Or damaged files? =-"
	echo "-= WARNING =-"
	read pause
fi

# MIT License
#
# Copyright (c) 2025 Chimbal
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
