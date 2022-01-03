#!/bin/bash
getnext(){
    DTS=$(date "+%s" )

    while IFS="|" read s
    do 
        if [ $s -gt $DTS ]; 
        then
            return $s
        fi
    done  < <(tail -n +2 list.csv | cut -d'|' -f2-3 |sed 's/|/ /' |date -f-  +%s |sort )
    return -1
}

getnext
d=`date -d @${s} "+%C%y-%m-%d|%r"`
date=$(cat list.csv | grep "$d")
