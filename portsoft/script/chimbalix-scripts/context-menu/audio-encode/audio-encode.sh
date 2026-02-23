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

Quality_OGG="-aq 4"
Quality_BIT="-b:a 128k"

if [ "$Codec" == "ogg" ] || [ "$Codec" == "mp3" ] || [ "$Codec" == "opus" ]; then
	Quality="$(zenity --list --column "Quality" --text "Audio Quality. Higher value = higher quality = larger size.\n 1 minute in 128 quality = ~1 MiB" --height=400 --width=400 '64' '80' '96' '112' '128' '160' '192' '224' '256' '320')"
	if [ "$Quality" == "" ]; then exit; fi
else
	exit
fi

if [[ "$Quality" =~ '64' ]];  then Quality_OGG="-aq 0"; Quality_BIT="-b:a 64k"; fi
if [[ "$Quality" =~ '80' ]];  then Quality_OGG="-aq 1"; Quality_BIT="-b:a 80k"; fi
if [[ "$Quality" =~ '96' ]];  then Quality_OGG="-aq 2"; Quality_BIT="-b:a 96k"; fi
if [[ "$Quality" =~ '112' ]]; then Quality_OGG="-aq 3"; Quality_BIT="-b:a 112k"; fi
if [[ "$Quality" =~ '128' ]]; then Quality_OGG="-aq 4"; Quality_BIT="-b:a 128k"; fi
if [[ "$Quality" =~ '160' ]]; then Quality_OGG="-aq 5"; Quality_BIT="-b:a 160k"; fi
if [[ "$Quality" =~ '192' ]]; then Quality_OGG="-aq 6"; Quality_BIT="-b:a 192k"; fi
if [[ "$Quality" =~ '224' ]]; then Quality_OGG="-aq 7"; Quality_BIT="-b:a 224k"; fi
if [[ "$Quality" =~ '256' ]]; then Quality_OGG="-aq 8"; Quality_BIT="-b:a 256k"; fi
if [[ "$Quality" =~ '320' ]]; then Quality_OGG="-aq 9"; Quality_BIT="-b:a 320k"; fi


# CheckName function
function CheckName {
	local FileName="$1"; local OutFileName="$FileName.$Codec"; local time="$(date +%s)"; local tx="${time:6}"
	if [ -e "$OutFileName" ]; then OutFileName="$FileName-new.$Codec"; if [ -e "$OutFileName" ]; then OutFileName="$FileName-new-$tx.$Codec"; fi; fi
	echo "$OutFileName"
}

# OPUS
if [ "$Codec" == "opus" ]; then
	echo "Audio Quality: $Quality_BIT"
	echo -e "Try to execute ffmpeg. \n"
	
	for i in "${!Files[@]}"; do
		CurrentFile="${Files[$i]}"
		OutputFileName="${CurrentFile%.*}"
		OutName="$OutputFileName-$Quality"
		
		# check if the output file exists
		OutName="$(CheckName "$OutName")"
		FileNameWithoutPath="$(basename "$OutName")"
		
		if $ffmpeg_exec -i "$CurrentFile" -acodec libopus $Quality_BIT "$OutName"; then echo "$FileNameWithoutPath: Finished."
		else
			echo "-= WARNING =-"
			echo "Something went wrong..."
			ErrorFiles="${ErrorFiles}\n $OutputFileName-$Quality.bad.opus"
			pause="1";
		fi
	done
fi

# OGG
if [ "$Codec" == "ogg" ]; then
	echo "Audio Quality: $Quality_BIT"
	echo -e "Try to execute ffmpeg. \n"
	
	for i in "${!Files[@]}"; do
		CurrentFile="${Files[$i]}"
		OutputFileName="${CurrentFile%.*}"
		OutName="$OutputFileName-$Quality"
		
		# check if the output file exists
		OutName="$(CheckName "$OutName")"
		FileNameWithoutPath="$(basename "$OutName")"
		
		if $ffmpeg_exec -i "$CurrentFile" -acodec libvorbis $Quality_BIT "$OutName"; then echo "$FileNameWithoutPath: Finished."
		else
			echo "-= WARNING =-"
			echo "Something went wrong..."
			ErrorFiles="${ErrorFiles}\n $OutputFileName-$Quality.bad.ogg"
			pause="1";
		fi
	done
fi

# MP3
if [ "$Codec" == "mp3" ]; then
	echo "Audio Quality: $Quality_BIT"
	echo -e "Try to execute ffmpeg. \n"
	
	for i in "${!Files[@]}"; do
		CurrentFile="${Files[$i]}"
		OutputFileName="${CurrentFile%.*}"
		OutName="$OutputFileName-$Quality"
		
		# check if the output file exists
		OutName="$(CheckName "$OutName")"
		FileNameWithoutPath="$(basename "$OutName")"
		
		if $ffmpeg_exec -i "$CurrentFile" -acodec libmp3lame $Quality_BIT "$OutName"; then echo "$FileNameWithoutPath: Finished."
		else
			echo "-= WARNING =-"
			echo "Something went wrong..."
			ErrorFiles="${ErrorFiles}\n $OutName"
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
