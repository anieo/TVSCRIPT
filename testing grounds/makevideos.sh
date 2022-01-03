#!/bin/bash


# for i in {1..5}
# do
#     ffmpeg -i video.mp4 -vf \
#     "drawtext=fontfile=/usr/share/fonts/truetype/lato/Lato-Medium.ttf:text='VIDEO $i':fontcolor=white:fontsize=48:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" \
#     -preset veryfast -codec:a copy video$i.mp4 &
# done
# ffmpeg -i video.mp4 -vf \
# "drawtext=fontfile=/usr/share/fonts/truetype/lato/Lato-Medium.ttf:text='VIDEO ADS':fontcolor=white:fontsize=48:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" \
# -preset veryfast -codec:a copy ads.mp4
ffmpeg -i video.mp4 -vf \
"drawtext=fontfile=/usr/share/fonts/truetype/lato/Lato-Medium.ttf:text='OVERLAY VIDEO ADS':fontcolor=white:fontsize=48:box=1:boxcolor=black@0.5:boxborderw=5:x=(w-text_w)/2:y=(h-text_h)/2" \
-preset veryfast -codec:a copy overlayads.mp4