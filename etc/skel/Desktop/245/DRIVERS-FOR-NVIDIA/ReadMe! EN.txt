-= ======================================== =-
-= ======================================== =-
-=  GOOD way to instal full NVIDIA drivers  =-
-=        (GTX900 Series and newer)         =-
-= ======================================== =-

NVIDIA CUDA Toolkit contains CUDA, OpenCL and other APIs needed by many applications such as Blender, Stable Diffusion and others.
Installing the CUDA Toolkit is the best way to avoid many of the problems that are common on Linux.

1) Download NVIDIA CUDA Toolkit (runfile local) for Debian 12 from https://developer.nvidia.com/cuda-toolkit-archive.

For example, tested with my GeForce GTX 1070:
https://developer.download.nvidia.com/compute/cuda/12.4.0/local_installers/cuda_12.4.0_550.54.14_linux.run

P.S.
Take a photo of these instructions:

1) Copy "cuda_xx...xx_linux.run" into "Home" directory.
2) Make the file "cuda_xx...xx_linux.run" executable.
3) Add Nouveau Driver to blacklist (run "Disable Nouveau.desktop") and reboot the system.

4) Press CTRL+ALT+F1 and login into system
5) sudo service lightdm stop  (in systemd: sudo systemctl stop lightdm.service)
6) sudo ./cuda_xx...xx_linux.run
7) If the installation went without errors: sudo reboot

If the installation goes wrong... Well, it's Linux, welcome to hell.

-= ======================= =-
-= ======================= =-
-= GTX 600 - RTX 30 Series =-
-= ======================= =-

Not suitable for rebrands from GTX 400-500 series!

Check the regular NVIDIA drivers on the official website: https://www.nvidia.com/drivers/

ATTENTION!
Please note that the old driver may not have Vulkan 1.3, which is required for current DXVK versions to work.

Use the "CHANGE_DVXK-1.10.3.sh" script in the Wine prefix directory to switch to the fallback DXVK version that works with Vulkan 1.2, which is located in the user's home directory (~/.wine/CHANGE_DVXK-1.10.3.sh -OR- /home/USER_NAME/.wine/CHANGE_DVXK-1.10.3.sh).

For example v470.256.02: https://www.nvidia.com/en-us/drivers/details/226760/

https://us.download.nvidia.com/XFree86/Linux-x86_64/470.256.02/NVIDIA-Linux-x86_64-470.256.02.run

-= ======================= =-
-= ======================= =-
-= GTX 400 - 1000 Series =-
-= ======================= =-

Warning! Old versions of drivers may be incompatible with new versions of the Linux kernel!
The problem can be solved by installing older versions of the Linux kernel.

Check the regular NVIDIA drivers on the official website: https://www.nvidia.com/drivers/

For example v390.157: https://www.nvidia.com/en-us/drivers/details/196213/

https://us.download.nvidia.com/XFree86/Linux-x86_64/390.157/NVIDIA-Linux-x86_64-390.157.run

