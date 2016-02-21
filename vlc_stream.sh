#!/usr/bin/bash

# Path to FFMPEG compiled with NVENC encode and DXVA2 decode
PATH=/cygdrive/c/ffmpeg-nvenc/:/cygdrive/c/Program\ Files/VideoLAN/VLC/:$PATH

source=${1}

vlc --quiet \
	--file-caching 1000 \
	--no-qt-video-autoresize \
	--playlist-autostart \
	--sout-keep \
	--sout '#transcode{vcodec=h264,qd=1}:duplicate{dst=file{mux=ts,dst=-},dst=display{no-audio=1,no-video=1}' \
	--sout-x264-profile high \
	--sout-x264-level 5.1 \
	--sout-x264-preset ultrafast \
	--sout-x264-tune lowlatency \
	--sout-mux-caching 1000 \
	"${source}" | \
ffmpeg  -y -loglevel fatal \
        -stats \
        -hwaccel dxva2 \
        -i - \
        -vcodec nvenc \
                -preset hp \
                -profile:v high \
                -level 5.1 \
                -r 25 \
		-i_qfactor 1.1 -b_qfactor 1.25 \
        -acodec libfdk_aac -b:a 128k -ac 2 \
        -f mpegts - | \
vlc --quiet -I dummy \
	--file-caching 1000 \
	--playlist-autostart \
	--no-qt-video-autoresize \
	--file-caching 1000 \
	--playlist-autostart \
	--sout-mux-caching 1000 \
	--sout-keep \
        --sout '#rtp{mux=ts,proto=udp,timeout=0,sdp=rtsp://:8554/}' -
