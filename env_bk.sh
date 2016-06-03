#!/bin/bash
DESDIR=/home/`whoami`/env_backup
#scan name
Package=(vim ruby python atom sublime xcode nodejs)
nInstall=()
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
				mkdir $DESDIR/vim_env 2> /dev/null
				cp -p /home/`whoami`/.vimrc $DESDIR/vim_env/`date +%Y%m%d`
				#crontab -l | { cat; echo "@daily bash `pwd`/vimbk.sh";} | crontab -
			elif [[ $i == 'ruby' ]]; then
				mkdir $DESDIR/ruby_env 2> /dev/null
				#crontab
			elif [[ $i == 'python' ]]; then
				mkdir $DESDIR/python_env 2> /dev/null
				pip list | tr -d "()" > $DESDIR/python_env/`date +%Y%m%d`
			elif [[ $i == 'atom' ]]; then
				mkdir $DESDIR/atom_env 2> /dev/null
			elif [[ $i == 'sublime' ]]; then
				mkdir $DESDIR/sublime_env 2> /dev/null
			elif [[ $i == 'xcode' ]]; then
				mkdir $DESDIR/xcode_env 2> /dev/null
			elif [[ $i == 'nodejs' ]]; then
				mkdir $DESDIR/nodejs_env 2> /dev/null
			fi
		else
			nInstall+=($i)
		fi
	done
	for n in "${nInstall[@]}" ; do
		echo "$n is not installed"
	done
#elif [[ $1 == '-u' ]] || [[ $1 == '--add' ]]; then
	#statements	
elif [[ $1 == '-l' ]] || [[ $1 == '--list' ]]; then
	ls -a $DESDIR/
elif [[ $1 == '-r' ]] || [[ $1 == '--restore' ]]; then
	if [[ $2 == '' ]]; then
		echo "which environment you want to restore"
		arr=($(ls ~/env_backup))
		for (( i = 0; i < ${#arr[@]}; i++ )); do
			echo "$((i+1)). ${arr[i]}"
		done
		printf "input a number:"
		read num
		restore_env=${arr[$((num - 1))]}
		echo "which one you want to restore"
		arr=($(ls ~/env_backup/$restore_env))
		for (( i = 0; i < ${#arr[@]}; i++ )); do
			echo "$((i+1)). ${arr[i]}"
		done
	elif [[ $2 == 'python' ]]; then
		ls $DESDIR/python_env
		#arr=($(awk '{print $1}' filename))
	fi
elif [[ $1 == '-d' ]] || [[ $1 == '--delete' ]]; then
	echo `ls $DESDIR | grep $2`
	#rm -rf $2
else
	echo "Wrong argument: $1" >&2
	exit 2
fi
exit 0
