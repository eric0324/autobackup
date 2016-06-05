#!/bin/bash
DESDIR=/home/`whoami`/.`whoami`_env

backup()
{
	cp -p ~/.vimrc $DESDIR/vim
}

reinstall()
{
	cd $DESDIR
	git checkout $1 vim
	cp -p $DESDIR/vim ~/.vimrc
	git checkout HEAD vim
	vim +PluginInstall +qall
}

if [[ $1 == '-b' ]]; then
	backup
elif [[ $1 == '-r' ]]; then
	reinstall $2
elif [[ $1 == '-c' ]]; then
	if [[ `find ~/ -name ".vimrc" -mtime -1` == '.vimrc' ]]; then
		backup
	fi
fi
