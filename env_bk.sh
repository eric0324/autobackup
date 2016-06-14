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
	bash ./github_setup.sh $DESDIR
elif [[ -f $DESDIR ]]; then
	echo "can't create dir: $DESDIR" >&2
	exit 1
fi
job=`crontab -l 2> /dev/null | grep ${PWD}| crontab -`
crontab -l 2> /dev/null | grep -v `pwd` | crontab -
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
	cronCMD+=" bash `pwd`/upload.sh;"
	#echo "$cronCMD"
	for n in "${nInstall[@]}" ; do
		echo "$n is not installed"
	done
	job=$cronCMD;
		;;
	-r | --recover )
	cd $DESDIR
	arr=(all)
	case $# in
		1 )
			echo "which environment you want to restore"
			arr+=($(ls $DESDIR))
			for (( i = 0; i < ${#arr[@]}; i++ )); do
				echo "$((i+1)). ${arr[i]}"
			done
			printf "input a number: "
			read num
			set -- "{@:1}" "${arr[$((num - 1))]}" 
			;&
		2 )
			echo "which day you want to restore"
			git log --pretty=format:"%s"
			printf "input date: "
			read mdate 
			set -- "{@:2}" "`git log --pretty=format:"%s %H" | awk /$mdate/'{print $2}'`"
			;;
	esac
	cd -
	if [[ $2 == 'all' ]]; then
		for (( i = 1; i < ${#arr[@]}; i++ )); do
			python ./backup.py -${arr[i]} $3
		done
	else
		python ./recover.py -$2 $3
	fi
	bash ./upload.sh
		;;
	-[Sm] | --set )
		Package_bk=($(ls $DESDIR))
		if [[ $2 == 'dir' ]] && [[ $3 != '' ]]; then
			awk -v dir=$3 '{ if(/DESDIR/) print "DESDIR="dir; else print $0 }' ./.config > /tmp/config.tmp 
			mv /tmp/config.tmp ./.config
			Package_bk=$(ls $3)
		elif [[ $2 == 'timer' ]]; then
			cronCMD="@"
			case $3 in
				Hourly | Daily | Weekly | Monthly | Yearly )
					cronCMD+="$3"
					;;
				* )
					interval=(Hourly Daily Weekly Monthly Yearly)
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
			cronCMD+=" python `pwd`/backup.py -$name;"
		done
		cronCMD+=" bash `pwd`/upload.sh;"
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
		exit 2
		;;
esac
(crontab -l; echo $job) | sort - | uniq - | crontab -
exit 0
