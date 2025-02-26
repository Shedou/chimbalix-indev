#!/usr/bin/env bash
# Script version 1.0
# LICENSE for this script is at the end of this file
# "$@" - Add all arguments.
# "shift;" - Move the command line arguments to one position left.
# Example usage (Thunar Custom Actions):
# Font styles
# Usage: "${B}Bold Text${N}"
B=$(tput bold)
N=$(tput sgr0)

Mode="$1"; shift; # arg 1
DPI="$1"; shift; # arg 2
Files=("$@")

ErrorFiles=""
GoodFiles=""
pause="0"

# DJVU
if [ "$Mode" == "djvu" ]; then
	
	echo -e "Try to execute ddjvu. \n"
	
	for i in "${!Files[@]}"; do
		CurrentFile="${Files[$i]}"
		OutputFileName="${CurrentFile%.*}"
		FileNameWithoutPath="$(basename "$OutputFileName")"
		
		if [ ! -e "$OutputFileName" ]; then
			Out="$OutputFileName"
			mkdir "$OutputFileName"
		else
			Out="$OutputFileName-new"
			mkdir "$OutputFileName-new"
		fi
		
		
		if ddjvu -verbose -format=tiff -scale=$DPI -eachpage -quality=95 "$CurrentFile" "$Out/$FileNameWithoutPath-%d.tiff"  ; then
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
		
		if [ ! -e "$OutputFileName" ]; then
			Out="$OutputFileName"
			mkdir "$OutputFileName"
		else
			Out="$OutputFileName-new"
			mkdir "$OutputFileName-new"
		fi
		
		
		if gs -dNOPAUSE -sDEVICE=jpeg -dJPEGQ=95 -r$DPI -sOutputFile="$Out/$FileNameWithoutPath-%03d.jpg" "$CurrentFile" -c quit ; then
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
