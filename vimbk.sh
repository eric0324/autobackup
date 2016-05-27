#!/bin/bash
DESDIR=/home/`whoami`/env_backup

if [[ `find ~/ -name ".vimrc" -mtime -1` == '.vimrc' ]]; then
	cp -p ~/.vimrc $DESDIR/vim_bk/`date +%Y%m%d`.vimrc
fi
