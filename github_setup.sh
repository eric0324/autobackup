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


temp=`curl -s -u $user https://api.github.com/user/keys -d "{\"title\": \"env ssh key\",\"key\": \"$key\" }" ` 

if  [ `echo $temp | grep Bad -c` -ge "1" ];then
i="0"
else
i="1"
fi




if [ `echo $temp | grep Maximun -c` -ge "1" ];then   #github lock acc
echo "too much woring login"
i="0"
until [ $i != "0" ]
do
echo "plz use this program later(github lock acc)"
read user
done
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


if  [ `echo $temp | grep Bad -c` -ge "1" ];then
i="0"
else
i="1"
fi


if [ `echo $temp | grep Maximun -c` -ge "1" ];then   #github lock acc
echo "too much woring login"
i="0"
until [ $i != "0" ]
do
echo "plz use this program later(github lock acc)"
read user
done
fi





done
fi

#..................................repo............................................................................


echo "create repo..."

echo " "

temp=`curl -s -u $user https://api.github.com/user/repos -d "{\"name\":\"$dirname\"}" ` 


if [ `echo $temp | grep Maximun -c` -ge "1" ];then   #github lock acc
echo "too much woring login"
i="0"
until [ $i != "0" ]
do
echo "plz use this program later(github lock acc)"
read user
done
fi


if  [ `echo $temp | grep already -c` -ge "1"  ];then
i='0'

echo "github repo is used  plz input your new dir name"
read dirname

elif  [ `echo $temp | grep Bad -c` -ge "1"  ];then
i='0'
echo "worng password input again"
else
i='1'
fi


if [ "$i" = '0' ]
then
until [ $i != "0" ]
do

temp=`curl -s -u $user https://api.github.com/user/repos -d "{\"name\":\"$dirname\"}" ` 


if [ `echo $temp | grep Maximun -c` -ge "1" ];then   #github lock acc
echo "too much woring login"
i="0"
until [ $i != "0" ]
do
echo "plz use this program later(github lock acc)"
read user
done
fi


if  [ `echo $temp | grep already -c` -ge "1"  ];then
i='0'

echo "github repo is used  plz input your new dir name"
read dirname

elif  [ `echo $temp | grep Bad -c` -ge "1"  ];then
i='0'
echo "worng password input again"
else
i='1'
fi

done
fi

#......................................................................................................................

ssh-add ~/.ssh/id_rsa

ssh -T git@github.com

git clone git@github.com:$user/$dirname.git $1

cd $1

git config user.name $user
git config user.email $user

echo "done"
