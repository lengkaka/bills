#!/bin/sh
for file in $* ; do
    echo $file
    sed 's/modul\/application/module\/application/' $file > tmp
    mv tmp $file
done
#sed 's/\.\.\/fonts\//\{PORTAL_DOMAIN\}\/fonts\//' common.css > tmp.css
