#!/bin/bash
DESDIR=/home/`whoami`/env_backup
#scan name
Package=(vim ruby python atom sublime xcode nodejs)
if [[ ! -e $DESDIR ]]; then
	mkdir $DESDIR
elif [[ -f $DESDIR ]]; then
	echo "can't create dir: $DESDIR" >&2
	exit 1
fi

if [[ $1 == '-a' ]] || [[ $1 == '--auto' ]]; then
	#scan & backup
	for i in "${Package[@]}"; do
		if [[ $( dpkg -s $i 2> /dev/null | grep Status ) == 'Status: install ok installed' ]]; then
			#echo "$i"
			if [[ $i == 'vim' ]]; then
				#full backup
				mkdir $DESDIR/vim_bk
				cp -p /home/`whoami`/.vimrc $DESDIR/vim_bk/`date +%Y%m%d`.vimrc
				#crontab -l | { cat; echo "@daily bash `pwd`/vimbk.sh";} | crontab -
			elif [[ $i == 'ruby' ]]; then
				mkdir $DESDIR/ruby_bk
				#crontab
			fi
		fi
	done
#elif [[ $1 == '-u' ]] || [[ $1 == '--add' ]]; then
	#statements	
elif [[ $1 == '-l' ]] || [[ $1 == '--list' ]]; then
	ls -a $DESDIR/
#elif [[ $1 == '-r' ]] || [[ $1 == '--restore' ]]; then
	#statements
elif [[ $1 == '-d' ]] || [[ $1 == '--delete' ]]; then
	echo `ls $DESDIR | grep $2`
	#rm -rf $2
else
	echo "Wrong argument: $1" >&2
	exit 2
fi
exit 0
