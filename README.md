# FFMPEG_NVENC2VLC_RTSP


ffmpeg_stream.sh and  vlc_stream.sh

Small Cygwin-bash scripts showing how to use FFMPEG compiled with NVidia HW encoder and other non-free libraries to rapidly transcode videos into Android compatible RTSP streams. It is in fact only 1 command line with a pipe.

The "ffmpeg" script works well but doesn't allow for seeking at all. The "vlc" script creates a ffmpeg sandwich between 2 VLC's. Doesn't work well at all but when it does it allows for seeking using the first VLC that opens the source. You can't push RAW from the first VLC to FFMPEG. It has to do some kind of encapsulation so I try to do a HW assisted decode and as close to a null encode as possible to lowlatency push into FFMPEG for HW encode.


I use these scripts to transcode and stream 3D and VR videos to cardboard players my Android Moto X Pure. You can adjust as needed for your needs.
It works for anything I've thrown at it so far. The one issue is that you can't seek the stream.
If you PAUSE VLC the pipe will will block and FFMPEG will pause appropriately.


The H264 codec, TS encapsulation and RTSP (UDP) transport are the best (only) way I've found to truly transcode a video on the fly in a way the default Android video player can play.
VLC, MXPlayer, etc can play other formats and configurations but at the moment there are no cardboard video players that do not use the built-in Android player functionality.

Why not HTTP transport and/or mp4 encapsulation? An mp4 encapsulated video has to be already encoded for streaming play before it can be progressive streamed via HTTP. When encoding to H264 the setting for that is typically called "fast-start", "web compatible", etc. What it does is after the video is encoded it moves the MOOV header that contains the library of what's being muxed to the head of the file. A stubborn player like the Android one will not render anything without first accessing that.


REQUIREMENTS:


1. FFMPEG Cross-Compiled to use NVidia's h264 hardware acceleration. This script and instructions worked very well for me. I use VirtualBox with an Ubuntu build to create the Linux compile environement (NOT Cygwin).
https://github.com/rdp/ffmpeg-windows-build-helpers
2. VideoLan's VLC - Just a normal windows build should be OK
3. Cygwin - Cygwin provides BASH which is an easier scripting language for me. BASH allows for visually breaking lines using "\"


OPTIONAL:

Can create a windows shortcut link with this in it and you can drag-drop a file onto the link to start the streaming with that file. Adjust as necessary for your environment. 

  C:\cygwin64\bin\mintty.exe C:\cygwin64\bin\bash.exe  -l -c  "bin/ffmpeg_stream.sh \"$0\"; sleep 30"


Similarly you can create an Explorer "Send To" option that you can right-click on a file

Need to put a shortcut link like above in this directory

  C:\Users\<your_user_name>\AppData\Roaming\Microsoft\Windows\SendTo


The how-to came from one of the answers in this question. http://stackoverflow.com/questions/9637601/open-cygwin-at-a-specific-folder


NOTES:


The FFMPEG NVENC source code. The definitive and mostly only documentation source for what parameters are available.

https://www.ffmpeg.org/doxygen/3.0/nvenc_8c_source.html


The FFMPEG (outbound) streaming guide helps with some ideas and parameters.

https://trac.ffmpeg.org/wiki/StreamingGuide 


The NVIDIA example documentation that shows how to make things go with some reasonable parameters to start with. Including a setting in the vein of x264's tune=file

http://developer.download.nvidia.com/compute/redist/ffmpeg/1511-patch/FFMPEG-with-NVIDIA-Acceleration-on-Ubuntu_UG_v01.pdf

