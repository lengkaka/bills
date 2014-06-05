#!/bin/bash

task_start() {
    #_cmd=`nohup fswatch .. coffee_static.sh >/dev/null 2>&1 &`
    #_cmd=`nohup fswatch .. coffee_static.sh > log.out 2>&1 &`
    _cmd=`nohup fswatch .. 'sh coffee_static.sh' >/dev/null 2>&1 &`
    #_cmd=`nohup fswatch .. 'ls' > log.out 2>&1  &`
    #_cmd=`nohup fswatch .. 'find .. -type f -name "*.coffee" | xargs coffee -c' > log.out 2>&1  &`
    #_cmd=`nohup fswatch .. ls > log.out 2>&1 &` 
    echo $_cmd
}

task_stop() {
    _force="-9"
    #_pids=`ps aux | grep 'fswatch.*coffee_static\.sh' | grep -v grep | awk '{print $2}'`
    _pids=`ps aux | grep 'fswatch' | grep -v grep | awk '{print $2}'`
    if [ "$_pids" != "" ] ; then
        kill $_force $_pids
    fi
}

task_restart() {
    task_stop
    echo "task restarting...pls wait..."
    task_start
}

action=$1

#处理
case "$action" in
    'start')
        task_start
    ;;
    'stop')
        task_stop
    ;;
    'restart')
        task_restart
    ;;
esac
#fswatch .. coffee_static.sh
