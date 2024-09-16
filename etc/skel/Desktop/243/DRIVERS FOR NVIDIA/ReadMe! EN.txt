
-= =================================== =-
-=  GOOD way to instal NVIDIA drivers  =-
-=      (GTX900 Series and newer)      =-
-= =================================== =-

NVIDIA CUDA Toolkit contains CUDA, OpenCL and other APIs needed by many applications such as Blender, Stable Diffusion and others. Installing the CUDA Toolkit is the best way to avoid many of the problems that are common on Linux.

1) Download NVIDIA CUDA Toolkit (runfile local) for Debian 12 from https://developer.nvidia.com/cuda-toolkit-archive.

For example, tested with my GeForce GTX 1070:
https://developer.download.nvidia.com/compute/cuda/12.4.0/local_installers/cuda_12.4.0_550.54.14_linux.run

P.S.
Take a photo of these instructions:

1) Copy "cuda_xx...xx_linux.run" into "Home" directory.
2) Make the file "cuda_xx...xx_linux.run" executable.
3) Add Nouveau Driver to blacklist (run "Disable Nouveau.desktop") and reboot the system.

4) Press CTRL+ALT+F1 and login into system
5) sudo service lightdm stop
6) sudo ./cuda_xx...xx_linux.run
7) If the installation went without errors: sudo reboot

If the installation goes wrong... Well, it's Linux, welcome to hell.

-= =================================== =-
-= Linux-Way (I don't recommend it...) =-
-= =================================== =-

This method will most likely make it difficult to update/change the NVIDIA driver and may also cause other graphics and dependency issues...

1) Use "MX-NVIDIA-INSTALLER" in the "Linux-Way" folder. (I hope it works, haven't tested it)

or

1) Search and read the documentation.
...
Perhaps these commands will help you install a full NVIDIA driver from the repositories, but this is not certain:

sudo apt-get update
sudo apt-get install nvidia-cuda-toolkit
