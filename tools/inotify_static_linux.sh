#!/bin/sh
while file=$(inotifywait -r -e modify --format "%w%f" ../); do
    EXT=${file##*.}
    if [ $EXT == "coffee" ] ; then 
            echo `sh coffee_static_linux.sh $file`
    elif [ $EXT == "tpl" ] ; then
            echo `sh template_static_linux.sh $file`
    fi
done
