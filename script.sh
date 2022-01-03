#!/bin/bash
csv="./list.csv"
getnext(){
    DTS=$(date "+%s" )

    while IFS="|" read s
    do 
        IFS='|'; line=($s); unset IFS;
        videoStart=${line[0]}
        b=${line[1]}
        time=(${b//:/ })
        h=${time[0]}
        min=${time[1]}
        sec=${time[2]}
        videoEnd=$(($videoStart+$h*60*60))
        videoEnd=$(($videoEnd+$min*60))
        videoEnd=$(($videoEnd+$sec))
        if [ $videoEnd -gt $DTS ]; 
        then
            return
        fi
    done  < <(tail -n +2 $csv | cut -d'|' -f2-4 | awk -F'|' '{cmd="date +%s -d \""$1" "$2"\"";system(cmd | getline $1 );print $1,$3}'  OFS='|' |sort -k1)
    return -1
}



while true
do
    getnext 2>/dev/null
    # echo $videoStart $end
    d=`date -d @${videoStart} "+%C%y-%m-%d|%r"`
    out=$(cat list.csv | grep "$d")
    IFS='|'; line=($out); unset IFS;
    echo "Sss" $d $out
    video=${line[0]}
    time_to_play=${line[1]}
    duration=${line[3]}
    overlay=${line[4]}
    videoOverlay=${line[5]}
    videoOverlay_start=${line[6]}

    vi="./videos/$video"
    start=`date +%s`
    remaining_start=$( echo "$videoEnd - $start" | bc )
    till_start=$( echo "$videoStart - $start" | bc )
    start_from=$( echo "$start - $videoStart" | bc )
    start_Hours=$(($start_from/3600))
    echo 1 $start_from $start_Hours:$start_minutes:$seconds
    start_from=$(($start_from-$start_Hours*3600))    
    echo 2 $start_from $start_Hours:$start_minutes:$seconds
    start_minutes=$(($start_from/60))
    echo 3 $start_from $start_Hours:$start_minutes:$seconds
    seconds=$(($start_from-$start_minutes*60))
    echo 4 $start_from $start_Hours:$start_minutes:$seconds
    start_from=$start_Hours:$start_minutes:$seconds
    echo 5 $start_from $start_Hours:$start_minutes:$seconds
    echo "till start :" $till_start 
    echo "duration :" $duration
    echo "start from :" $start_from
    echo "remaining :" $remaining_start
    if [ $remaining_start -gt 0 -a $till_start -lt 0 ]; then
        echo "Streamin Videos"
        yes "q" | ffmpeg  -loglevel error -ss $start_from -re -i "$vi" -i "$overlay" -filter_complex "[0:v][1:v]overlay" \
            -codec:v libx264 -pix_fmt yuv420p -preset veryfast -b:v 2500k -g 60.0 -codec:a aac -b:a 128k -ar 44100 -maxrate 2500k -bufsize 1250k -strict experimental -t $duration -f flv  "rtmp://" -y </dev/null 
        end=`date +%s`
        runtime=$( echo "$end - $start" | bc -l )
    fi
    getnext
    end=`date +%s`

    next=$( echo "$videoStart - $end " | bc -l )

    d=`date -d @${videoStart} "+%C%y-%m-%d|%r"`
    remaining=`date -d @$next -u "+%M:%S"`
    
    echo "next" $next
    if [  $till_start -gt 0 -a $next -gt 0 ]; then
        echo "Streaming ADS"
        yes "q" | ffmpeg  -loglevel error -re -i "./videos/ads.mp4" -i "overlay/nologo.png" -filter_complex "[0:v][1:v]overlay" \
        -codec:v libx264 -pix_fmt yuv420p -preset veryfast -b:v 2500k -g 60.0 -codec:a aac -b:a 128k -ar 44100 -maxrate 2500k -bufsize 1250k -strict experimental -t $remaining -f flv  "rtmp://" -y </dev/null 
    fi

done
