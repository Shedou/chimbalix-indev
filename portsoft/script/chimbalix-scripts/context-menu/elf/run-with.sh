#!/usr/bin/env bash
# Script version 1.0
# LICENSE for this script is at the end of this file

Executable="$1"; shift
ExeName="$(basename "$Executable")";

Command=""
Params=""

MODE_CUSTOM_LOCALE="false"
MODE_GAMEMODE="false"
MODE_WINE="false"
MODE_WINE_MORE="false"
MODE_OVERLAY_MANGOHUD="false"
MODE_OVERLAY_GALLIUM="false"
MODE_OVERLAY_MESA="false"
MODE_FORCE_NV="false"
MODE_FORCE_INTEL_GPU="false"
MODE_FORCE_DRI_0="false"
MODE_FORCE_DRI_1="false"
MODE_OGLVK_FORCE_SOFTWARE="false"

echo -e "Executable: $Executable\nWaiting for user selection..."

if [ "$LANG" == "ru_RU.UTF-8" ]; then
	ZENITY_TEXT="Некоторые параметры могут не работать в зависимости от комбинации параметров,\nконфигурации системы и запускаемого приложения.\nЗапуск: \"$ExeName\""
	ZENITY_HELP="Custom Locale:\n  Позволяет переопределить локализацию при запуске приложения.\n\nGamemode:\n  Применить оптимизации для улучшения производительности.\n\nWINE:\n  Позволяет запускать Windows приложения с помощью WINE.\n\nOverlay - ... :\n  Отображает информацию о производительности в играх.\n\nForce CPU Rendering ... :\n  Использовать CPU для отрисовки графики.\n\nForce GPU ... :\n  Принудительно использовать выбранный GPU при наличии нескольких видеокарт в сиcтеме."
else
	ZENITY_TEXT="Some options may not work depending on the combination of options,\nsystem configuration, and application you are running.\nLaunch: \"$ExeName\""
	ZENITY_HELP="Custom Locale:\n Allows you to override the locale when the application starts.\n\nGamemode:\n Apply optimizations to improve performance.\n\nWINE:\n Allows you to launch Windows applications using WINE.\n\nOverlay - ... :\n Displays information about game performance.\n\nForce CPU Rendering ... :\n Use the CPU to render graphics.\n\nForce GPU ... :\n Force the selected GPU to be used if there are multiple video cards in the system."
fi

function _MAIN() {
	_TIME_TO_CHOICE
	_CHECK_PARAMS
	_ENABLE_MODES
	_EXECUTABLE
}

function _TIME_TO_CHOICE() {
	Params="$(zenity --list --checklist --multiple --title="Run with..." --text="$ZENITY_TEXT" --height=440 --column="--" --column="Mode" i 'Run without modifiers' i 'Custom Locale...' i 'Gamemode' i 'WINE' i 'WINE - More Options...' i 'Overlay - Mangohud (OpenGL/Vulkan)' i 'Overlay - Gallium HUD (OpenGL)' i 'Overlay - Mesa HUD (Vulkan)' i 'Force CPU Rendering (OpenGL/Vulkan, llvmpipe)' i 'Force GPU - NVIDIA' i 'Force GPU - Intel' i 'Force GPU - 0 (DRI_PRIME)' i 'Force GPU - 1 (DRI_PRIME)' i 'HELP!')"
	if [ "$Params" == "" ]; then exit; fi
}

function _CHECK_PARAMS() {
	if [[ "$Params" =~ 'Run without modifiers' ]]; then :
	else
		if [[ "$Params" =~ 'HELP!' ]]; then
			Help="$(zenity --info --title="Help..." --text="$ZENITY_HELP" --height=440)"
			_MAIN
		else
			if [[ "$Params" =~ 'Custom Locale' ]];						then MODE_CUSTOM_LOCALE="true"; fi
			if [[ "$Params" =~ 'Gamemode' ]];							then MODE_GAMEMODE="true"; fi
			if [[ "$Params" =~ 'WINE' ]];								then MODE_WINE="true"; fi
			if [[ "$Params" =~ 'WINE - More Options...' ]];				then MODE_WINE_MORE="true"; fi
			if [[ "$Params" =~ 'Overlay - Mangohud (OpenGL/Vulkan)' ]];	then MODE_OVERLAY_MANGOHUD="true"; fi
			if [[ "$Params" =~ 'Overlay - Gallium HUD (OpenGL)' ]];		then MODE_OVERLAY_GALLIUM="true"; fi
			if [[ "$Params" =~ 'Overlay - Mesa HUD (Vulkan)' ]];		then MODE_OVERLAY_MESA="true"; fi
			if [[ "$Params" =~ 'Force GPU - NVIDIA' ]];					then MODE_FORCE_NV="true"; fi
			if [[ "$Params" =~ 'Force GPU - Intel' ]];					then MODE_FORCE_INTEL_GPU="true"; fi
			if [[ "$Params" =~ 'Force GPU - 0 (DRI_PRIME)' ]];			then MODE_FORCE_DRI_0="true"; fi
			if [[ "$Params" =~ 'Force GPU - 1 (DRI_PRIME)' ]];			then MODE_FORCE_DRI_1="true"; fi
			if [[ "$Params" =~ 'Force CPU Rendering (OpenGL/Vulkan, llvmpipe)' ]];	then MODE_OGLVK_FORCE_SOFTWARE="true"; fi
		fi
	fi
	echo -e "Choice: $Params"
}

function _ENABLE_MODES() {
	if [ "$MODE_CUSTOM_LOCALE" == "true" ]; then
		export LC_ALL="$(zenity --list 'ru_RU.UTF-8' 'en_US.UTF-8' 'ja_JP.UTF-8' 'zh_CN.UTF-8' 'zh_TW.UTF-8' 'С.UTF-8' --column='Locales' --title="Select Locale" --height=440 --width=400)"
		if [ "$LC_ALL" == "" ]; then exit; fi
	fi
	
	if [ "$MODE_WINE_MORE" == "true" ]; then
		Wine_Params="$(zenity --list --checklist --multiple --title="WINE Settings..." --text="Select settings..." --height=440 --column="--" --column="Option" i 'Run without modifiers' i 'DXVK - Set FPS Limit...' i 'DXVK - Monitoring Short' i 'DXVK - Monitoring Full' i 'DXVK/VKD3D - Force GPU...' --height=440 --width=400)"
		if [ "$Wine_Params" == "" ]; then exit; fi
		
		if [[ "$Wine_Params" =~ 'Run without modifiers' ]]; then :
		else
			if [[ "$Wine_Params" =~ 'DXVK - Set FPS Limit...' ]]; then
				export DXVK_FRAME_RATE="$(zenity --list 320 240 160 144 120 75 60 30 20 15 10 --column=FPS --editable --title="Set FPS Limit..." --text="Works only when using DXVK!\nDouble click to edit!" --height=440 --width=400)"
				if [ "$DXVK_FRAME_RATE" == "" ]; then exit; fi
			fi
			
			if [[ "$Wine_Params" =~ 'DXVK - Monitoring Short' ]]; then
				export DXVK_HUD=version,api,devinfo,gpuload,fps,frametimes,drawcalls,memory,opacity=1.0; fi
			
			if [[ "$Wine_Params" =~ 'DXVK - Monitoring Full' ]]; then
				export DXVK_HUD=full,opacity=1.0; fi
			
			if [[ "$Wine_Params" =~ 'DXVK/VKD3D - Force GPU...' ]]; then
				GPU_NAMES="$(vulkaninfo --summary | grep deviceName | cut -c23-256)"
				OLD_IFS=$IFS; IFS=$"\n"; while read -r line; do GPU_NAMES_ARRAY+=("$line"); done <<< "$GPU_NAMES"; IFS=$OLD_IFS
				export DXVK_FILTER_DEVICE_NAME="$(zenity --list --column="GPU Name" --title="Select GPU..." --text="Works only when using DXVK/VKD3D!" --height=440 --width=400 "${GPU_NAMES_ARRAY[@]}")"
				if [ "$DXVK_FILTER_DEVICE_NAME" == "" ]; then exit; fi
			fi
		fi
		echo -e "Choice (WINE): $Wine_Params"
	fi
	
	if [ "$MODE_OVERLAY_GALLIUM" == "true" ]; then
		MONITORGPU=".w200.h100fps:160,.w200.h100GPU-load:100,.w200.h100temperature:100"
		MONITORCPU=".w200.h100cpu0+cpu1+cpu2+cpu3+cpu4+cpu5+cpu6+cpu7+cpu8+cpu9+cpu10+cpu11+cpu12+cpu13+cpu14+cpu15:100"
		export GALLIUM_HUD=${MONITORGPU},${MONITORCPU}
	fi
	
	if [ "$MODE_OVERLAY_MESA" == "true" ]; then
		export VK_INSTANCE_LAYERS=VK_LAYER_MESA_overlay
		export VK_LAYER_MESA_OVERLAY_CONFIG=device=1,format=0,fps=1,frame=1,submit=1,draw=1,pipeline_graphics=1,pipeline_compute=1,pipeline_raytracing=1,width=400,height=20
	fi
	
	if [ "$MODE_OGLVK_FORCE_SOFTWARE" == "true" ]; then
		export LIBGL_ALWAYS_SOFTWARE=true
		export __GLX_VENDOR_LIBRARY_NAME=mesa
		export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/lvp_icd.x86_64.json
	fi
	
	if [ "$MODE_FORCE_NV" == "true" ]; then
		export __VK_LAYER_NV_optimus=NVIDIA_only
		export __NV_PRIME_RENDER_OFFLOAD=1
		export __GLX_VENDOR_LIBRARY_NAME=nvidia
		if [ -e "/etc/vulkan/icd.d/nvidia_icd.json" ]; then
			export VK_ICD_FILENAMES=/etc/vulkan/icd.d/nvidia_icd.json
		elif [ -e "/usr/share/vulkan/icd.d/nvidia_icd.x86_64.json" ]; then
			export VK_ICD_FILENAMES=/usr/share/vulkan/icd.d/nvidia_icd.x86_64.json
		fi
	fi
	
	if [ "$MODE_FORCE_INTEL_GPU" == "true" ]; then
		export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=iGPU
		__VK_LAYER_NV_optimus=non_NVIDIA_only
		__NV_PRIME_RENDER_OFFLOAD=1
		__GLX_VENDOR_LIBRARY_NAME=intel
	fi
	
	
	if [ "$MODE_FORCE_DRI_0" == "true" ]; then export DRI_PRIME=0; fi
	if [ "$MODE_FORCE_DRI_1" == "true" ]; then export DRI_PRIME=1; fi
	
	if [ "$MODE_GAMEMODE" == "true" ]; then Command="gamemoderun"; fi
	if [ "$MODE_OVERLAY_MANGOHUD" == "true" ]; then
		export MANGOHUD_DLSYM=1
		export LD_PRELOAD="/usr/lib/x86_64-linux-gnu/mangohud/libMangoHud_dlsym.so:/usr/lib/x86_64-linux-gnu/mangohud/libMangoHud.so"
		#export LD_PRELOAD="/usr/lib/i386-linux-gnu/mangohud/libMangoHud_dlsym.so:/usr/lib/i386-linux-gnu/mangohud/libMangoHud.so" # i386
		if [ "$Command" == "" ]; then Command="mangohud"
		else Command="$Command mangohud"; fi
	fi
	
	if [ "$MODE_WINE" == "true" ]; then
		if [ "$Command" == "" ]; then Command="wine"
		else Command="$Command wine"; fi
	fi
}

function _EXECUTABLE() {
	if ! [[ -x "$Executable" ]] && [ "$MODE_WINE" == "false" ]; then
		echo -e "\n WARNING! The file does not have permission to run!\n Try making the file executable? Enter \"y\" or \"yes\" to confirm."
		read confirm
		if [ "$confirm" == "y" ] || [ "$confirm" == "yes" ]; then if ! chmod +x "$Executable"; then echo " Error setting launch permissions. Abort."; exit; fi
		else echo "Abort."; read pause; fi
	fi
	
	$Command "$Executable"
	exit_code="$?"
	
	if [[ "$exit_code" != "0" ]]; then
		echo -e "\n ATTENTION! Exit code: $exit_code\n Pause..."
		read pause
	fi
	
	
}

_MAIN


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
