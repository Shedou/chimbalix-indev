#!/usr/bin/env bash
# Script version 1.0
# LICENSE for this script is at the end of this file

# Font styles
# Usage: "${B}Bold Text${N}"
B=$(tput bold); N=$(tput sgr0)

Format="$1"; shift; # arg 1
#Compression="$1"; shift; # arg 2
#Type="$1"; shift; # arg 3

Compression="90"
Type="default"
CustomColors="false"

# Variables
Exec=convert; ErrorFiles=""; GoodFiles=""; pause="0"; Files=("$@")
OutQuality=""; OutType=""; OutAlpha=""; TQ=""; TT=""

if [ "$Format" == "jpg" ]; then
	Compression="$(zenity --list Custom 100 92 85 75 60 50 40 35 30 25 10 --column "Quality" --text "Image quality.\nHigher value = higher quality = larger size." --height=400)"
	Type="TrueColor"
	if [ "$Compression" == "Custom" ]; then
		Type="$(zenity --list default "CustomColors" TrueColor GrayScale Palette BiLevel TrueColor-BlackBG GrayScale-BlackBG Palette-BlackBG BiLevel-BlackBG --column "Image Type" --text "TrueColor = full color image. | GrayScale = grayscale.\nPalette = indexed color palette. | BiLevel = black/white.\n*-BlackBG = Converts background to black\n(if original has alpha channel)" --height=400)"
		if [ "$Type" == "CustomColors" ]; then
			CustomColors="true"
			OutAlpha="-alpha remove"
			Type="$(zenity --list 4 8 16 32 64 128 256 --column "Number of colors" --text "Double click to edit.\nBetter to use with PNG format." --editable --height=300)"
		fi
		if [ "$Type" == "" ]; then exit; fi
		Compression="$(zenity --list 100 92 85 75 60 50 40 35 30 25 10 --column "Quality" --text "Image quality.\nHigher value = higher quality = larger size." --height=400)"
	fi
	if [ "$Compression" == "" ]; then exit; fi
	
elif [ "$Format" == "png" ]; then
	Compression="$(zenity --list Custom 90 80 70 60 50 40 30 20 10 --column "Compression" --text "Compression ratio.\nHigher value = smaller size = slower." --height=400)"
	if [ "$Compression" == "Custom" ]; then
		Type="$(zenity --list default CustomColors TrueColor GrayScale Palette BiLevel TrueColor-BlackBG GrayScale-BlackBG Palette-BlackBG BiLevel-BlackBG --column "Image Type" --text "All options disable the Alpha channel (except \"default\").\nTrueColor = full color image. | GrayScale = grayscale.\nPalette = indexed color palette. | BiLevel = black/white.\n*-BlackBG = Converts background to black\n(if original has alpha channel)" --height=400)"
		if [ "$Type" == "CustomColors" ]; then
			CustomColors="true"
			OutAlpha="-alpha remove"
			Type="$(zenity --list 4 8 16 32 64 128 256 --column "Number of colors" --text "Double click to edit" --editable --height=300)"
		fi
		if [ "$Type" == "" ]; then exit; fi
		Compression="$(zenity --list Custom 90 80 70 60 50 40 30 20 10 --column "Compression" --text "Compression ratio.\nHigher value = smaller size = slower." --height=400)"
	fi
	if [ "$Compression" == "" ]; then exit; fi
	
elif [ "$Format" == "webp" ]; then
	Compression="$(zenity --list Custom 100 92 85 75 60 50 40 35 30 25 10 --column "Quality" --text "Image quality.\nHigher value = higher quality = larger size." --height=400)"
	if [ "$Compression" == "Custom" ]; then
		Type="$(zenity --list default CustomColors TrueColor GrayScale Palette BiLevel TrueColor-BlackBG GrayScale-BlackBG Palette-BlackBG BiLevel-BlackBG --column "Image Type" --text "TrueColor = full color image. | GrayScale = grayscale.\nPalette = indexed color palette. | BiLevel = black/white.\n*-BlackBG = Converts background to black\n(if original has alpha channel)" --height=400)"
		if [ "$Type" == "CustomColors" ]; then
			CustomColors="true"
			OutAlpha="-alpha remove"
			Type="$(zenity --list 4 8 16 32 64 128 256 --column "Number of colors" --text "Double click to edit.\nBetter to use with PNG format." --editable --height=300)"
		fi
		if [ "$Type" == "" ]; then exit; fi
		Compression="$(zenity --list 100 92 85 75 60 50 40 35 30 25 10 --column "Quality" --text "Image quality.\nHigher value = higher quality = larger size." --height=400)"
	fi
	if [ "$Compression" == "" ]; then exit; fi
	
else exit
fi

# Processing args
if [ "$Compression" != "default" ]; then OutQuality="-quality $Compression"; fi

if [ "$Type" != "default" ]; then
	if [ "$CustomColors" == "true" ]; then
		OutType="-colors $Type"
	else
		OutType="-type $Type"
	fi
	TT="-$Type"
	if [ "$Type" == "TrueColor" ] || [ "$Type" == "GrayScale" ] || [ "$Type" == "Palette" ] || [ "$Type" == "BiLevel" ]; then
		OutAlpha="-alpha remove"
	fi
	if [ "$Type" == "TrueColor-BlackBG" ] || [ "$Type" == "GrayScale-BlackBG" ] || [ "$Type" == "Palette-BlackBG" ] || [ "$Type" == "BiLevel-BlackBG" ]; then
		OutType="-type ${Type%.*}"
		OutAlpha="-background #000000 -alpha remove"
	fi
fi

# CheckName function
function CheckName {
	local FileName="$1"; local OutFileName="$FileName.$Format"; local time="$(date +%s)"; local tx="${time:6}"
	if [ -e "$OutFileName" ]; then OutFileName="$FileName-new.$Format"; if [ -e "$OutFileName" ]; then OutFileName="$FileName-new-$tx.$Format"; fi; fi
	echo "$OutFileName"
}

# JPEG Module
if [ "$Format" == "jpg" ]; then
	TQ="-q$Compression"
	echo -e "Try to convert. \n"
	for i in "${!Files[@]}"; do
		CurrentFile="${Files[$i]}"
		OutputFileName="${CurrentFile%.*}"
		OutName="$OutputFileName$TQ"
		
		# check if the output file exists
		OutName="$(CheckName "$OutName")"
		
		FileNameWithoutPath="$(basename "$OutName")"
		
		# Run prepared command
		if $Exec -strip $OutAlpha $OutQuality $OutType "$CurrentFile" "$OutName"; then echo "$FileNameWithoutPath: Finished."
		else ErrorFiles="${ErrorFiles}\n $OutName"; pause="1"; fi
	done
fi

# PNG Module
if [ "$Format" == "png" ]; then
	echo -e "Try to convert. \n"
	for i in "${!Files[@]}"; do
		CurrentFile="${Files[$i]}"
		OutputFileName="${CurrentFile%.*}"
		OutName="$OutputFileName$TT"
		
		# check if the output file exists
		OutName="$(CheckName "$OutName")"
		
		FileNameWithoutPath="$(basename "$OutName")"
		
		# Run prepared command
		if $Exec -strip $OutAlpha $OutQuality $OutType "$CurrentFile" "$OutName"; then echo "$FileNameWithoutPath: Finished."
		else ErrorFiles="${ErrorFiles}\n $OutName"; pause="1"; fi
	done
fi

# WebP Module
if [ "$Format" == "webp" ]; then
	TQ="-q$Compression"
	echo -e "Try to convert. \n"
	for i in "${!Files[@]}"; do
		CurrentFile="${Files[$i]}"
		OutputFileName="${CurrentFile%.*}"
		OutName="$OutputFileName$TQ"
		
		# check if the output file exists
		OutName="$(CheckName "$OutName")"
		
		FileNameWithoutPath="$(basename "$OutName")"
		
		# Run prepared command
		if $Exec -strip $OutAlpha $OutQuality $OutType "$CurrentFile" "$OutName"; then echo "$FileNameWithoutPath: Finished."
		else ErrorFiles="${ErrorFiles}\n $OutName"; pause="1"; fi
	done
fi

if [ "$pause" == "1" ]; then
	echo -e "\
	-= WARNING =-
	-= List of not finished or corrupted files:
	$ErrorFiles
	\n-= Not enough system memory? Or damaged files? =-"
	read pause
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
