#!/bin/bash
CWD=$(cd "$(dirname $0)";pwd)
mkdir -p $CWD/temp
mkdir -p $CWD/logs
mkdir -p $CWD/www
mkdir -p $CWD/www/hls
chmod 777 $CWD/www/hls
chmod a+x $CWD/easydss
chmod a+x $CWD/*.so
chmod a+x $CWD/*.sh

$CWD/easydss -s stop > /dev/null 2>&1
nohup $CWD/easydss > /dev/null 2>&1 &
