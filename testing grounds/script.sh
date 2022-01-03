#!/bin/bash
video="./videoplayback (2).mp4"
overlay="../overlay/logo.png"
while true
do

    ffmpeg -re -f flv -i "$video" -i $overlay -filter_complex "[1:v][0:v]scale2ref=w=oh*mdar:h=ih/10[logo][video-out],[video-out][logo]overlay=main_w-overlay_w-10:main_h-overlay_h-10" \
    -pix_fmt yuv420p -c:v libx264 -c:a copy -f flv \
    rtmp://localhost/live/stream
done