#!/usr/bin/env bash
# Script version 1.0
# LICENSE for this script is at the end of this file

# TEMPLATE_PATH_TO_EXE
# TEMPLATE_MODE_TERMINAL
# TEMPLATE_NAME
# TEMPLATE_ICON

source "$HOME/.config/user-dirs.dirs"

Path_To_Script="$( dirname "$(readlink -f "$0")")"
Path_To_EXE="$1"
Mode_Terminal="false"
Session_Number="$RANDOM"

Template_Desktop_File="/portsoft/script/chimbalix-scripts/context-menu/sendto/template.desktop"
Input_EXE_File="$(basename "$Path_To_EXE")"
Input_EXE_File_Without_Ext="${Input_EXE_File%.*}"

Output_Desktop_Dir="$XDG_DESKTOP_DIR"
Output_Desktop_File="$Output_Desktop_Dir/$Input_EXE_File_Without_Ext.desktop"
Output_Icon="/portsoft/script/chimbalix-scripts/context-menu/sendto/template-icon.png"

echo " $Session_Number"

echo " $Input_EXE_File"
echo " $Input_EXE_File_Without_Ext"

if [ -e "$Output_Desktop_File" ]; then
	Output_Desktop_File="$Output_Desktop_Dir/$Input_EXE_File_Without_Ext""_$Session_Number"".desktop"
fi

echo " $Output_Desktop_File"


read pause
read pause
read pause

cp "$Template_Desktop_File" "$Output_Desktop_File"

echo " $Output_Desktop_File"

read pause
read pause
read pause

sed -i -e "s~TEMPLATE_PATH_TO_EXE~$Path_To_EXE~g" "$Output_Desktop_File"
sed -i -e "s~TEMPLATE_MODE_TERMINAL~$Mode_Terminal~g" "$Output_Desktop_File"
sed -i -e "s~TEMPLATE_NAME~$Input_EXE_File (Launcher)~g" "$Output_Desktop_File"
sed -i -e "s~TEMPLATE_ICON~$Output_Icon~g" "$Output_Desktop_File"

echo " complete"
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