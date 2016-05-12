#!/bin/bash
TIME=`date +%Y%m%d`
DESDIR=/home/`whoami`/env_backup
Package=(vim ruby python atom sublime xcode nodejs)
if [[ ! -e $DESDIR ]]; then
	mkdir $DESDIR
elif [[ -f $DESDIR ]]; then
	echo "can't create dir: $DESDIR" >&2
	exit 1
fi

#vim
#rsync -ut ~/.zshrc $DESDIR
if [[ $1 == '-a' ]] || [[ $1 == '--auto' ]]; then
	#scan & backup
	for i in "${Package[@]}"; do
		if [[ $( dpkg -s $i 2> /dev/null | grep Status ) == 'Status: install ok installed' ]]; then
			#crontab 
			echo "$i"
			BK_TIME="$DESDIR/$TIME"
			mkdir $BK_TIME
			if [[ $i == 'vim' ]]; then
				mkdir $BK_TIME/vim

			fi	
		fi
	done
#elif [[ $1 == '-u' ]] || [[ $1 == '--add' ]]; then
	#statements	
#elif [[ $1 == 'l' ]] || [[ $1 == '--list' ]]; then
	#statements
#elif [[ $1 == 'r' ]] || [[ $1 == '--restore' ]]; then
	#statements
#elif [[ $1 == 'd' ]] || [[ $1 == '--delete' ]]; then
	#statements
else
	echo "Wrong argument: $1" >&2
	exit 2
fi
exit 0
