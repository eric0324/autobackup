#!/bin/bash
DESDIR=/home/`whoami`/.`whoami`_env

backup()
{
	cp -p ~/.vimrc $DESDIR/vimrc
	cd $DESDIR
	git add vimrc
	git commit -m"vim`date +%Y%m%d`"
	#git push
}

reinstall()
{
	cd $DESDIR
	git checkout $1 vimrc
	cp -p $DESDIR/vimrc ~/.vimrc
	vim +PluginInstall +qall
	git checkout HEAD vimrc
}

if [[ $1 == '-b' ]]; then
	backup
elif [[ $1 == '-r' ]]; then
	cp -p $DESDIR/vimrc ~/.vimrc
	vim +PluginInstall +qall
elif [[ $1 == '-c' ]]; then
	if [[ `find ~/ -name ".vimrc" -mtime -1` == '.vimrc' ]]; then
		backup
	fi
fi
