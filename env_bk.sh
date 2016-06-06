#!/bin/bash
DESDIR=/home/`whoami`/.`whoami`_env
#scan name
Package=(vim ruby python atom nodejs git)
nInstall=()
cronCMD='@daily '
if [[ ! -e $DESDIR ]]; then
	git init $DESDIR
elif [[ -f $DESDIR ]]; then
	echo "can't create dir: $DESDIR" >&2
	exit 1
fi

if [[ $1 == '-s' ]] || [[ $1 == '--scan' ]]; then
	#scan & backup
	for i in "${Package[@]}"; do
		if [[ $( dpkg -s $i 2> /dev/null | grep Status ) == 'Status: install ok installed' ]]; then
			if [[ ! -e $DESDIR/$i ]]; then
				python ./backup.py -$i
			fi
			cronCMD+="python `pwd`/backup.py -$i;"
		else
			nInstall+=($i)
		fi
	done
	#echo "$cronCMD"
	for n in "${nInstall[@]}" ; do
		echo "$n is not installed"
	done
	#crontab -l | { cat; echo "@daily bash upload.sh";} | crontab -
elif [[ $1 == '-l' ]] || [[ $1 == '--list' ]]; then
	ls $DESDIR/
elif [[ $1 == '-r' ]] || [[ $1 == '--restore' ]]; then
	if [[ $2 == '' ]]; then
		cd $DESDIR
		echo "which environment you want to restore"
		arr=(all)
		arr+=($(ls $DESDIR))
		for (( i = 0; i < ${#arr[@]}; i++ )); do
			echo "$((i+1)). ${arr[i]}"
		done
		printf "input a number: "
		read num
		echo "which day you want to restore"
		git log --pretty=format:"%s"
		printf "input date: "
		read mdate 
		set -- "{@:1}" "${arr[$((num - 1))]}" "`git log --pretty=format:"%s %H" | awk /$mdate/'{print $2}'`"
		cd -
	fi
	python recover.py -$2 $3
else
	echo "Wrong argument: $1" >&2
	exit 2
fi
exit 0
