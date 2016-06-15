#!/bin/sh
echo "input your github acc" 
read user
dirname="env_backup"  #name of github repo

if ! [ -f "/home/$USER/.ssh/id_rsa" ];then
	ssh-keygen -t rsa
fi

key=`cat ~/.ssh/id_rsa.pub`




#..................................ssh.........................................................................

echo "using your ssh-key to connection github..."

i="0"

temp=`curl -s -u $user https://api.github.com/user/keys -d "{\"title\": \"env ssh key\",\"key\": \"$key\" }" ` 

if  [ `echo $temp | grep already -c` = "1" ]||[ `echo $temp | grep tru -c` = "1"  ];then
i="1"
fi


if [ "$i" = '0' ]
then

until [ $i != "0" ]
do

echo "   "
echo "worng username or password input again"
echo "   "
echo "input your github acc" 
read user

temp=`curl -s -u $user https://api.github.com/user/keys -d "{\"title\": \"env ssh key\",\"key\": \"$key\" }" ` 

if  [ `echo $temp | grep already -c` = "1" ]||[ `echo $temp | grep tru -c` = "1"  ];then
i="1"
fi

done
fi

#..................................repo............................................................................


echo "create repo..."
i="0"
echo " "

i=`curl -s -u $user https://api.github.com/user/repos -d "{\"name\":\"$dirname\"}" | grep Bad -c ` 

if [ "$i" = '1' ]
then

until [ $i != "1" ]
do
echo "worng password input again"

i=`curl -s -u $user https://api.github.com/user/repos -d "{\"name\":\"$dirname\"}" | grep Bad -c ` 

done

fi

#......................................................................................................................

ssh-add id_rsa

ssh -T git@github.com

git clone git@github.com:$user/$dirname.git $1

cd $1

git config user.name $user
git config user.email $user

echo "done"
