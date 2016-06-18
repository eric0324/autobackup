#!/bin/bash
source `dirname $0`/.config
cd $DESDIR
git add .
git commit -m "`date +%d%m%Y-%H%M-%S`"
git push
exit

