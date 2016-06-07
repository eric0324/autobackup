#!/bin/bash

if [[ ! -e ./.config ]]; then
	echo "
DESDIR=/home/\`whoami\`/.env_backup
Package=(vim ruby python atom nodejs git)
cronCMD='@daily'
	" > .config
fi
source ./.config
nInstall=()
if [[ ! -e $DESDIR ]]; then
	echo "initialization..."
	git init $DESDIR
#	bash ./env_init.sh `basename $DESDIR`
elif [[ -f $DESDIR ]]; then
	echo "can't create dir: $DESDIR" >&2
	exit 1
fi
case $1 in
	-s | --scan )
	#scan & backup
	for i in "${Package[@]}"; do
		if [[ $( dpkg -s $i 2> /dev/null | grep Status ) == 'Status: install ok installed' ]]; then
			if [[ ! -e $DESDIR/$i ]]; then
				python ./backup.py -$i
			fi
			cronCMD+=" python `pwd`/backup.py -$i;"
		else
			nInstall+=($i)
		fi
	done
	#echo "$cronCMD"
	for n in "${nInstall[@]}" ; do
		echo "$n is not installed"
	done
	#crontab -l | { cat; echo "@daily bash upload.sh";} | crontab -
		;;
	-r | --recover )
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
	python ./recover.py -$2 $3
		;;
	-[Sm] | --set )
		if [[ $2 == 'dir' ]]; then
			awk -v dir=$3 '{ if(/DESDIR/) print "DESDIR="dir; else print $0 }' ./.config > /tmp/config.tmp 
			mv /tmp/config.tmp ./.config
			python ./recovery.py -all HEAD
		fi
		;;
	-l | --list)
	ls $DESDIR/
		;;
	*)
	echo "Wrong argument: $1" >&2
	exit 2
		;;
esac

exit 0
