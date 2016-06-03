#!/bin/bash
DESDIR=/home/`whoami`/.`whoami`_env
#scan name
Package=(vim ruby python atom sublime xcode nodejs git)
nInstall=()
cronCMD='@daily '
if [[ ! -e $DESDIR ]]; then
	#mkdir $DESDIR
	git init $DESDIR
elif [[ -f $DESDIR ]]; then
	echo "can't create dir: $DESDIR" >&2
	exit 1
fi

if [[ $1 == '-a' ]] || [[ $1 == '--auto' ]]; then
	#scan & backup
	for i in "${Package[@]}"; do
		if [[ $( dpkg -s $i 2> /dev/null | grep Status ) == 'Status: install ok installed' ]]; then
			if [[ $i == 'vim' ]]; then
				if [[ ! -e $DESDIR/vimrc ]]; then
					bash ./vim.sh -b
				fi
				cronCMD+="bash `pwd`/vim.sh -c||"
				#crontab -l | { cat; echo "@daily bash `pwd`/vimbk.sh";} | crontab -
			elif [[ $i == 'git' ]]; then
				if [[ ! -e $DESDIR/gitconfig ]]; then
					cp -p ~/.gitconfig $DESDIR/gitconfig
				fi
				cronCMD+="bash `pwd`/git.sh -b"
			elif [[ $i == 'ruby' ]]; then
				cronCMD+="python `pwd`/ruby.py -b||"
			elif [[ $i == 'python' ]]; then
				cronCMD+="python `pwd`/python.py -b||"
				pip list | tr -d "()" > $DESDIR/python_env
			elif [[ $i == 'atom' ]]; then
				cronCMD+="python `pwd`/atom.py -b||;"
			elif [[ $i == 'sublime' ]]; then
				cronCMD+="python `pwd`/sublime.py -b||"
			elif [[ $i == 'xcode' ]]; then
				cronCMD+="python `pwd`/xcode.py -b||"
			elif [[ $i == 'nodejs' ]]; then
				cronCMD+="python `pwd`/nodejs.py -b||"
			fi
		else
			nInstall+=($i)
		fi
	done
	echo "$cronCMD"
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
		printf "input a number: "
		read num
		restore_env=${arr[$((num - 1))]}
		echo "which one you want to restore"
		arr=($(ls ~/env_backup/$restore_env))
		for (( i = 0; i < ${#arr[@]}; i++ )); do
			echo "$((i+1)). ${arr[i]}"
		done
		printf "input a number: "
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
