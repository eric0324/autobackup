#!/bin/bash

if [[ ! -e `dirname $0`/.config ]]; then
	echo "#config
DESDIR=/home/$USER/.env_backup
Package=(vim ruby python atom nodejs git)
cronCMD='@daily'
	" > .config
fi
source `dirname $0`/.config
nInstall=()
if [[ ! -e $DESDIR ]]; then
	echo "initialization..."
	bash ./github_setup.sh $DESDIR
elif [[ -f $DESDIR ]]; then
	echo "can't create dir: $DESDIR" >&2
	exit -1
fi
job=`crontab -l 2> /dev/null | grep ${PWD}`
crontab -l 2> /dev/null | grep -v `pwd` | crontab -
case $1 in
	-s | --scan )
	#scan & backup
	for i in "${Package[@]}"; do
		if [[ `dpkg -s $i 2> /dev/null | grep Status` == 'Status: install ok installed' ]]; then
			if [[ ! -e $DESDIR/$i ]]; then
				python `dirname $(readlink -f $0)`/backup.py -$i
			fi
			cronCMD+=" python `dirname $(readlink -f $0)`/backup.py -$i;"
		else
			nInstall+=($i)
		fi
	done
	cronCMD+=" bash `dirname $(readlink -f $0)`/upload.sh;"
	for n in "${nInstall[@]}" ; do
		echo "$n is not installed"
	done
	job=$cronCMD;
	bash `dirname $0`/upload.sh
		;;
	-r | --recover )
	envlist=(all)
	if [[ $4 != '' ]] ; then
		if [[ -e $4 ]] && [[ -e $4/.git ]]; then
			DESDIR=$4
		else 
			echo "can not recover from $4"
			exit -3
		fi
	fi
	echo "recover from $DESDIR ..."
	cd $DESDIR
	case $# in
		1 )
			echo "which environment you want to restore"
			envlist+=($(ls))
			if [[ ${#envlist[@]} == 1 ]]; then
				echo "There is nothing to restore from $DESDIR"
				exit -4
			fi
			for (( i = 0; i < ${#envlist[@]}; i++ )); do
				echo "$((i+1)). ${envlist[i]}"
			done
			printf "input a number: "
			read num
			set -- "$1" "${envlist[$((num - 1))]}" 
			;&
		2 )
			echo "which day you want to restore"
			git log --pretty=format:"%s" | cat
			printf "input date: "
			read mdate 
			date_arr=($(git log --pretty=format:"%s %H" | awk /$mdate/'{print $2}'))
			set -- "$1" "$2" "${date_arr[0]}"
			;;
	esac
	cd -
	if [[ $2 == 'all' ]]; then
		for (( i = 1; i < ${#envlist[@]}; i++ )); do
			python `dirname $0`/recovery.py -${envlist[i]} $3
		done
	else
		python `dirname $0`/recovery.py -$2 $3
	fi
	bash `dirname $0`/upload.sh
		;;
	-[Sm] | --set )
		Package_bk=($(ls $DESDIR))
		if [[ $2 == 'dir' ]] && [[ $3 != '' ]]; then
			awk -v dir=$3 '{ if(/DESDIR/) print "DESDIR="dir; else print $0 }' `dirname $0`/.config > /tmp/config.tmp 
			mv /tmp/config.tmp `dirname $0`/.config
			Package_bk=($(ls $3))
		elif [[ $2 == 'timer' ]]; then
			cronCMD="@"
			case $3 in
				hourly | daily | weekly | monthly | yearly )
					cronCMD+="$3"
					;;
				* )
					interval=(hourly daily weekly monthly yearly)
					for (( i = 0; i < ${#interval[@]}; i++ )); do
						echo "$((i+1)). ${interval[i]}"
					done
					printf "input number:"
					read num
					cronCMD+=${interval[$((num-1))]}
					;;
			esac
		else
			echo "Wrong argument"
		fi
		for name in "${Package_bk[@]}"; do
			cronCMD+=" python `dirname $(readlink -f $0)`/backup.py -$name;"
		done
		cronCMD+=" bash `dirname $(readlink -f $0)`/upload.sh;"
		job=$cronCMD
		;;
	-d | --disable )
		job=""
		;;
	-l | --list )
		ls $DESDIR/
		;;
	* )
		echo "Wrong argument: $1" >&2
		exit -2
		;;
esac
(crontab -l; echo $job) | sort - | uniq - | crontab -
exit 0
