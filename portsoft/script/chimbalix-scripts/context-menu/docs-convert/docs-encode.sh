#!/usr/bin/env bash
# Script version 1.0
# LICENSE for this script is at the end of this file
B=$(tput bold)
N=$(tput sgr0)

Mode="$1"; shift; # arg 1
Files=("$@")

ErrorFiles=""
GoodFiles=""
pause="0"

DPI="96"

if [ "$Mode" == "djvu" ] || [ "$Mode" == "pdf" ]; then
	OutSizeDPI="$(zenity --list --column "Output Size (DPI)" --text "DPI (Dots Per Inch). Higher value = larger size.\nThe size in pixels depends on the parameters of the original document." --height=400 --width=400 '72' '96' '150' '200' '300' '600' '1200')"
	if [ "$OutSizeDPI" == "" ]; then exit; fi
	DPI="$OutSizeDPI"
else
	exit
fi

# CheckName function
function CheckName {
	local FileName="$1"; local OutFileName="$FileName"; local time="$(date +%s)"; local tx="${time:6}"
	if [ -e "$OutFileName" ]; then OutFileName="$FileName-new"; if [ -e "$OutFileName" ]; then OutFileName="$FileName-new-$tx"; fi; fi
	echo "$OutFileName"
}

# DJVU
if [ "$Mode" == "djvu" ]; then
	
	echo -e "Try to execute ddjvu. \n"
	
	for i in "${!Files[@]}"; do
		CurrentFile="${Files[$i]}"
		OutputFileName="${CurrentFile%.*}"
		FileNameWithoutPath="$(basename "$OutputFileName")"
		OutName="$OutputFileName-$DPI"
		
		# check if the output file exists
		OutName="$(CheckName "$OutName")"
		
		mkdir -p "$OutName"
		Out="$OutName/$FileNameWithoutPath-%03d.tiff"
		
		echo "Processing: $CurrentFile"
		if ddjvu -format=tiff -scale=$DPI -eachpage -quality=93 "$CurrentFile" "$Out"  ; then
			:
		else
			echo "-= WARNING =-"
			echo "Something went wrong..."
			ErrorFiles="${ErrorFiles}\n $OutputFileName"
			pause="1";
		fi
	done
fi

# PDF
if [ "$Mode" == "pdf" ]; then
	
	echo -e "Try to execute gs. \n"
	
	for i in "${!Files[@]}"; do
		CurrentFile="${Files[$i]}"
		OutputFileName="${CurrentFile%.*}"
		FileNameWithoutPath="$(basename "$OutputFileName")"
		OutName="$OutputFileName-$DPI"
		
		# check if the output file exists
		OutName="$(CheckName "$OutName")"
		
		mkdir -p "$OutName"
		Out="$OutName/$FileNameWithoutPath-%03d.jpg"
		
		if gs -dNOPAUSE -sDEVICE=jpeg -dJPEGQ=95 -r$DPI -sOutputFile="$Out" "$CurrentFile" -c quit ; then
			:
		else
			echo "-= WARNING =-"
			echo "Something went wrong..."
			ErrorFiles="${ErrorFiles}\n $OutputFileName"
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
