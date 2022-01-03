#!/bin/bash
csv="./list.csv"
getnext(){
    DTS=$(date "+%s" )

    while IFS="|" read s
    do 
        if [ $s -gt $DTS ]; 
        then
            return $s
        fi
    done  < <(tail -n +2 $csv | cut -d'|' -f2-3 |sed 's/|/ /' |date -f-  +%s |sort )
    return -1
}



while true
do
    getnext
    d=`date -d @${s} "+%C%y-%m-%d|%r"`
    out=$(cat list.csv | grep "$d")
    IFS='|'; line=($out); unset IFS;

    video=${line[0]}
    time_to_play=${line[1]}
    duration=${line[3]}
    overlay=${line[4]}
    videoOverlay=${line[5]}
    videoOverlay_start=${line[6]}

    vi="./videos/$video"
    start=`date +%s`
    st=$( echo "$s - $start" | bc )
    echo $st 
    echo $duration
    if [ $st -lt 10 ]; then
        echo ${line[@]}
        yes "q" | ffmpeg  -loglevel error -re -i "$vi" -i "$overlay" -filter_complex "[0:v][1:v]overlay" \
            -codec:v libx264 -pix_fmt yuv420p -preset veryfast -b:v 2500k -g 60.0 -codec:a aac -b:a 128k -ar 44100 -maxrate 2500k -bufsize 1250k -strict experimental -t $duration -f flv  "rtmp://" -y </dev/null > /dev/null
        end=`date +%s`
        runtime=$( echo "$end - $start" | bc -l )
    fi
    getnext
    end=`date +%s`

    next=$( echo "$s - $end - 3" | bc -l )
    echo $s
    d=`date -d @${s} "+%C%y-%m-%d|%r"`
    remaining=`date -d @$next -u "+%M:%S"`
    if [ $next -gt 10 ]; then
        echo "ADS"
        yes "q" | ffmpeg  -loglevel error -re -i "./videos/ads.mp4" -i "overlay/nologo.png" -filter_complex "[0:v][1:v]overlay" \
        -codec:v libx264 -pix_fmt yuv420p -preset veryfast -b:v 2500k -g 60.0 -codec:a aac -b:a 128k -ar 44100 -maxrate 2500k -bufsize 1250k -strict experimental -t $remaining -f flv  "rtmp://" -y </dev/null > /dev/null  
    fi

done
