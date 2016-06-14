#!/bin/sh
echo "input your github acc" 
read user
dirname="env_backup"  #name of github repo

if ! [ -f "/home/$USER/.ssh/id_rsa" ];then
	ssh-keygen -t rsa
fi

key=`cat ~/.ssh/id_rsa.pub`
echo "create repo..."

curl -u $user https://api.github.com/user/keys -d "{\"title\": \"env ssh key\",\"key\": \"$key\" }"
curl -u $user https://api.github.com/user/repos -d "{\"name\":\"$dirname\"}"

ssh-add id_rsa

ssh -T git@github.com

git clone git@github.com:$user/$dirname.git $1

cd $1

git config user.name $user
git config user.email $user

echo "done"
