#!/bin/bash
source ./.config
cd $DESDIR
git add .
git commit -m "`date +%Y%m%d`"
git push
exit
