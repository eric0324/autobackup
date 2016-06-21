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

until [ $i != "0" ]
do


temp=`curl -s -u $user https://api.github.com/user/keys -d "{\"title\": \"env ssh key\",\"key\": \"$key\" }" ` 



if  [ `echo $temp | grep Bad -c` -ge "1" ];then
echo "   "
echo "worng username or password input again"
echo "   "
echo "input your github acc" 
read user
i="0"
elif [ `echo $temp | grep Max -c` -ge "1" ];then   #github lock acc
echo "too much woring login"
echo "Maximum number of login attempts exceeded. Please try again later"
i="0"

exit 5

else
i="1"
fi

done





#..................................repo............................................................................


echo "create repo..."
echo " "

i="0"

until [ $i != "0" ]
do

temp=`curl -s -u $user https://api.github.com/user/repos -d "{\"name\":\"$dirname\"}" ` 



if  [ `echo $temp | grep Bad -c` -ge "1" ];then
echo "   "
echo "worng  password input again"
i="0"
elif [ `echo $temp | grep Max -c` -ge "1" ];then   #github lock acc
echo "too much woring login"
echo "Maximum number of login attempts exceeded. Please try again later"
i="0"

exit 5

elif  [ `echo $temp | grep already -c` -ge "1"  ];then

echo "github repo is used.  please input your new repo name."
read dirname
i='0'
else
i="1"
fi

done




#......................................................................................................................

ssh-add ~/.ssh/id_rsa

ssh -T git@github.com

git clone git@github.com:$user/$dirname.git $1

cd $1

git config user.name $user
git config user.email $user

echo "done"
