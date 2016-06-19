#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd -P )"
nInstall=()
job=`crontab -l 2> /dev/null | grep $SCRIPT_DIR`
crontab -l 2> /dev/null | grep -v `pwd` | crontab -

github_init() {
	if [[ ! -e $DESDIR ]]; then
		echo "initialization..."
		bash ./github_setup.sh $DESDIR
	elif [[ -f $DESDIR ]]; then
		echo "can't create dir: $DESDIR" >&2
		echo "automatic backup has been clear"
		exit -1
	fi
}

if [[ ! -e $SCRIPT_DIR/.config ]]; then
	echo "#config
DESDIR=$SCRIPT_DIR/autobackup
Package=(vim ruby python atom nodejs git)
cronCMD='@daily'
	" > .config
fi
source $SCRIPT_DIR/.config

case $1 in
	-s | --scan )
	#scan & backup
	github_init
	for i in "${Package[@]}"; do
		if [[ `dpkg -s $i 2> /dev/null | grep Status` == 'Status: install ok installed' ]]; then
			if [[ ! -e $DESDIR/$i ]]; then
				python $SCRIPT_DIR/backup.py -$i
			fi
			cronCMD+=" python $SCRIPT_DIR/backup.py -$i;"
		else
			nInstall+=($i)
		fi
	done
	cronCMD+=" bash $SCRIPT_DIR/upload.sh;"
	for n in "${nInstall[@]}" ; do
		echo "$n is not installed"
	done
	job=$cronCMD;
	bash $SCRIPT_DIR/upload.sh
		;;
	-r | --recover )
	envlist=(all)
	if [[ $4 != '' ]] ; then
		if [[ -e $4 ]] && [[ -e $4/.git ]]; then
			DESDIR=$4
		else 
			echo "can not recover from $4"
			(crontab -l; echo $job) | sort - | uniq - | crontab -
			exit -3
		fi
	else
		github_init
	fi
	echo "recover from $DESDIR ..."
	cd $DESDIR
	envlist+=($(ls))
	if [[ ${#envlist[@]} == 1 ]]; then
		echo "There is nothing to restore from $DESDIR"
		(crontab -l; echo $job) | sort - | uniq - | crontab -
		exit -4
	fi
	case $# in
		1 )
			echo "which environment you want to restore"
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
			python $SCRIPT_DIR/recovery.py -${envlist[i]} $3 $DESDIR
			python $SCRIPT_DIR/backup.py -${envlist[i]}
		done
	else
		python $SCRIPT_DIR/recovery.py -$2 $3 $DESDIR
		python $SCRIPT_DIR/backup.py -$2
	fi
	echo "upload ..."
	bash $SCRIPT_DIR/upload.sh
		;;
	-[Sm] | --set )
		Package_bk=($(ls $DESDIR))
		if [[ $2 == 'dir' ]] && [[ $3 != '' ]]; then
			awk -v dir=$3 '{ if(/DESDIR/) print "DESDIR="dir; else print $0 }' $SCRIPT_DIR/.config > /tmp/config.tmp 
			mv /tmp/config.tmp $SCRIPT_DIR/.config
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
			cronCMD+=" python $SCRIPT_DIR/backup.py -$name;"
		done
		cronCMD+=" bash $SCRIPT_DIR/upload.sh;"
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
