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
			#crontab 
			#echo "$i"
			BK_TIME="$DESDIR/`date +%Y%m%d`"
			mkdir $BK_TIME
			if [[ $i == 'vim' ]]; then
				mkdir $BK_TIME/vim
				cp /home/`whoami`/.vimrc $BK_TIME/vim/.vimrc
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
