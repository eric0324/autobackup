#!/bin/sh
echo "input your github acc" 
read user
dirname="env_backup"  #name of github repo

if ! [ -f "/home/$USER/.ssh/id_rsa" ];then
	ssh-keygen -t rsa
fi

key=`cat ~/.ssh/id_rsa.pub`

echo "using your ssh-key to connection github..."

i=`curl -s -u $user https://api.github.com/user/keys -d "{\"title\": \"env ssh key\",\"key\": \"$key\" }" | grep Bad -c `

if [ "$i" = '1' ]
then

until [ $i != "1" ]
do
echo "   "
echo "worng username or password input again"
echo "   "
echo "input your github acc" 
read user

i=`curl -s -u $user https://api.github.com/user/keys -d "{\"title\": \"env ssh key\",\"key\": \"$key\" }" | grep Bad -c `

done
fi

echo "create repo..."
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

ssh-add id_rsa

ssh -T git@github.com

git clone git@github.com:$user/$dirname.git $1

cd $1

git config user.name $user
git config user.email $user

echo "done"
