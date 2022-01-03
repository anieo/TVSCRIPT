#!/bin/bash

csv="./list.csv"

while true
do

    while IFS='|' read -r video time_to_play duration overlay URL
    do
        vi="./videos/$video"
        yes "q" | ffmpeg -re -i "$vi" -i "$overlay" -filter_complex "[1:v][0:v]scale2ref=w=oh*mdar:h=ih/10[logo][video-out],[video-out][logo]overlay=main_w-overlay_w-10:main_h-overlay_h-10"\
        -pix_fmt yuv420p -c:v libx264  -f flv  "rtmp://a.rtmp.youtube.com/live2/9yk9-jgg1-c7jj-rkxe-7qp2" -y </dev/null
        
    done < <(tail -n +2 $csv)


done