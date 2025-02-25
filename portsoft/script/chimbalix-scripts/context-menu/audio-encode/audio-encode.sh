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

Codec="$1"; shift; # arg 1
QualityAudio="$1"; shift; # arg 2
Files=("$@")

#
ffmpeg_exec=ffmpeg
ErrorFiles=""
GoodFiles=""
pause="0"

# OGG
if [ "$Codec" == "ogg" ]; then
	libvorbis_q="-aq 4"
	
	if [ "$QualityAudio" == "bad" ]; then libvorbis_q="-aq 0"  # 64
	elif  [ "$QualityAudio" == "low" ]; then libvorbis_q="-aq 2" # 96
	elif  [ "$QualityAudio" == "med" ]; then libvorbis_q="-aq 4" # 128
	elif  [ "$QualityAudio" == "hi" ]; then libvorbis_q="-aq 5" # 160
	elif  [ "$QualityAudio" == "hi192" ]; then libvorbis_q="-aq 6" # 192
	elif  [ "$QualityAudio" == "best" ]; then libvorbis_q="-aq 8" # 256
	fi
	
	echo "Audio Quality: $libvorbis_q"
	echo -e "Try to execute ffmpeg. \n"
	
	for i in "${!Files[@]}"; do
		CurrentFile="${Files[$i]}"
		OutputFileName="${CurrentFile%.*}"
		if [ ! -f "$OutputFileName.ogg" ]; then
			Out="$OutputFileName.bad.ogg"
		else
			Out="$OutputFileName-ogg.bad.ogg"
		fi
		
		if $ffmpeg_exec -i "$CurrentFile" -acodec libvorbis $libvorbis_q "$Out"; then
			echo "Finished. Renaming file to normal."
			if [ ! -f "$OutputFileName.ogg" ]; then
				echo "if"
				mv "$Out" "$OutputFileName.ogg"
				GoodFiles="${GoodFiles}\n $OutputFileName.ogg"
			else
				echo "else"
				mv "$Out" "$OutputFileName-ogg.ogg"
				GoodFiles="${GoodFiles}\n $OutputFileName-ogg.ogg"
			fi
		else
			echo "-= WARNING =-"
			echo "Something went wrong..."
			ErrorFiles="${ErrorFiles}\n $OutputFileName.bad.ogg"
			pause="1";
		fi
	done
fi

CPU_Threads=4 # $(cat /proc/cpuinfo | grep processor | wc -l)
CPU_Cores=1
NUMBER=4

if [ "$CPU_Threads" -le "2" ]; then CPU_Cores=1
elif [ "$CPU_Threads" -le "4" ]; then CPU_Cores=2
elif [ "$CPU_Threads" -le "8" ]; then CPU_Cores=4
elif [ "$CPU_Threads" -le "12" ]; then CPU_Cores=6
elif [ "$CPU_Threads" -le "16" ]; then CPU_Cores=8
elif [ "$CPU_Threads" -le "32" ]; then CPU_Cores=16
else CPU_Cores=20
fi


# OGG experimental
if [ "$Codec" == "ogg-new" ]; then
	libvorbis_q="-aq 4"
	
	if [ "$QualityAudio" == "bad" ]; then libvorbis_q="-aq 0"  # 64
	elif  [ "$QualityAudio" == "low" ]; then libvorbis_q="-aq 2" # 96
	elif  [ "$QualityAudio" == "med" ]; then libvorbis_q="-aq 4" # 128
	elif  [ "$QualityAudio" == "hi" ]; then libvorbis_q="-aq 5" # 160
	elif  [ "$QualityAudio" == "hi192" ]; then libvorbis_q="-aq 6" # 192
	elif  [ "$QualityAudio" == "best" ]; then libvorbis_q="-aq 8" # 256
	fi
	
	echo "Audio Quality: $libvorbis_q"
	echo -e "Try to execute ffmpeg. \n"
	
	for i in "${!Files[@]}"; do
		CurrentFile="${Files[$i]}"
		OutputFileName="${CurrentFile%.*}"
		if [ ! -f "$OutputFileName.ogg" ]; then
			Out="$OutputFileName.ogg"
		else
			Out="$OutputFileName-ogg.ogg"
		fi
		
		((ii=ii%NUMBER)); ((ii++==0)) && wait
		
		$ffmpeg_exec -i "$CurrentFile" -acodec libvorbis $libvorbis_q "$Out" &
	done
fi


# OGG Old Function
if [ "$Codec" == "ogg-old" ]; then
	libvorbis_q="-aq 4"
	
	if [ "$QualityAudio" == "bad" ]; then libvorbis_q="-aq 0"  # 64
	elif  [ "$QualityAudio" == "low" ]; then libvorbis_q="-aq 2" # 96
	elif  [ "$QualityAudio" == "med" ]; then libvorbis_q="-aq 4" # 128
	elif  [ "$QualityAudio" == "hi" ]; then libvorbis_q="-aq 5" # 160
	elif  [ "$QualityAudio" == "hi192" ]; then libvorbis_q="-aq 6" # 192
	elif  [ "$QualityAudio" == "best" ]; then libvorbis_q="-aq 8" # 256
	fi
	
	echo "Audio Quality: $libvorbis_q"
	echo -e "Try to execute ffmpeg. \n"
	
	for i in "${!Files[@]}"; do
		CurrentFile="${Files[$i]}"
		OutputFileName="${CurrentFile%.*}"
		if [ ! -f "$OutputFileName.ogg" ]; then
			Out="$OutputFileName.bad.ogg"
		else
			Out="$OutputFileName-ogg.bad.ogg"
		fi
		
		if $ffmpeg_exec -i "$CurrentFile" -acodec libvorbis $libvorbis_q "$Out"; then
			echo "Finished. Renaming file to normal."
			if [ ! -f "$OutputFileName.ogg" ]; then
				echo "if"
				mv "$Out" "$OutputFileName.ogg"
				GoodFiles="${GoodFiles}\n $OutputFileName.ogg"
			else
				echo "else"
				mv "$Out" "$OutputFileName-ogg.ogg"
				GoodFiles="${GoodFiles}\n $OutputFileName-ogg.ogg"
			fi
		else
			echo "-= WARNING =-"
			echo "Something went wrong..."
			ErrorFiles="${ErrorFiles}\n $OutputFileName.bad.ogg"
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
