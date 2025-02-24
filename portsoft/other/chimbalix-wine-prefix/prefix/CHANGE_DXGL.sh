#!/usr/bin/env bash
# Script version 1.0

Path_To_Script="$( dirname "$(readlink -f "$0")")"
cd "$Path_To_Script"

rm "dxvk"
ln -s "dxgl" "dxvk"
