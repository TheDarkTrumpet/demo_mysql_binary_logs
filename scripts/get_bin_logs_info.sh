#!/bin/sh

cmd='SHOW BINARY LOGS'
echo $cmd
echo $cmd | mysql

echo "\n------------\n"

cmd='SHOW MASTER STATUS'
echo $cmd
echo $cmd | mysql
