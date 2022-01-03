#!/bin/bash
getnext(){
    DTS=$(date "+%s" )

    while IFS="|" read s
    do 
        IFS='|'; line=($s); unset IFS;
        t=${line[0]}
        b=${line[1]}
        time=(${b//:/ })
        h=${time[0]}
        min=${time[1]}
        sec=${time[2]}
        end=$(($t+$h*60*60))
        end=$(($end+$min*60))
        end=$(($end+$sec))
        if [ $end -gt $DTS ]; 
        then
            echo $end
            return
        fi
    done  < <(tail -n +2 list.csv | cut -d'|' -f2-4 | awk -F'|' '{cmd="date +%s -d \""$1" "$2"\"";system(cmd | getline $1 );print $1,$3}'  OFS='|' |sort -k1)
    return -1
}

getnext 
echo $t $end
# d=`date -d @${s} "+%C%y-%m-%d|%r"`
# date=$(cat list.csv | grep "$d")
