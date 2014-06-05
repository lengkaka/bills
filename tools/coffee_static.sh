#!/bin/sh
    #echo `find . -type f -name '*.coffee' | xargs coffee -c`
    #echo `find . -type f -name '*.coffee'`
    # compile coffee
    echo `find .. -type f -name "*.coffee" | xargs coffee -c`
    # compile tpl
    echo `php staticCompile.php`

