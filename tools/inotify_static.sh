#!/bin/bash

task_start() {
    _sys=`uname`
    if [ "$_sys" == "Linux" ] ; then
        echo "Is Linux"
        _cmd=`nohup sh inotify_static_linux.sh >/dev/null 2>&1 &`
    elif [ "$_sys" == "Darwin" ] ; then
        echo "Is MAC"
        _cmd=`nohup fswatch .. 'sh coffee_static.sh' >/dev/null 2>&1 &`
    fi
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
