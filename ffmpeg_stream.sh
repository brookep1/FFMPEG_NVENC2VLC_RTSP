#!/usr/bin/bash

#################
#################
# Edit Path to the correct FFMPEG and VLC

PATH=/cygdrive/c/ffmpeg-nvenc/:/cygdrive/c/Program\ Files/VideoLAN/VLC/:$PATH

#
#################
#################


# FFMPEG will read the source using DXVA2 HW decode
# It is used without the "-re" flag so it will read and transcode the source as fast as it can.
# The stats printed will tell you if FFMPEG is able to transcode frames fast enough for play.
# and encode using NVIDIA NVENC H264 HW encode
# The device I'm using (Moto X Pure) supports H2264 High 5.1. I've set the preset to High Quality
# The I-frame and B-frame factors were given in the NVIDIA sample as tunings for film type graphics. (not CG or anime)
# Frame rate is dropped to 25fps. Some of the Oculus VR source material is 60fps.
# The transcoded H264 video and AAC audio are encapsulated into mpegts and piped to VLC
# The controls display for VLC is popped open but with no video or audio. 
# Seek won't work but pause will work. Also it seems without controls enabled the pipe won't be flow controlled by the video frame rate.

ffmpeg  -y -loglevel fatal \
	-stats \
	-hwaccel dxva2 \
	-i "${1}" \
	-vcodec nvenc \
		-preset hq \
		-profile:v high \
		-level 5.1 \
		-r 25 \
                -i_qfactor 1.1 -b_qfactor 1.25 \
	-acodec libfdk_aac -b:a 128k -ac 2 \
	-f mpegts - | \
vlc --quiet \
	--playlist-autostart \
	--no-qt-video-autoresize \
	--sout-keep \
	--sout '#duplicate{dst="rtp{mux=ts,proto=udp,timeout=0,sdp=rtsp://:8554/}", dst=display{no-audio=1,no-video=1}' -
