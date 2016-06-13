#!/bin/sh
echo "input your github acc" 
read user
dirname="mybackup"  #name of github repo



if ! [ -f "/home/$USER/.ssh/id_rsa" ];then

ssh-keygen -t rsa

fi




cd ~/.ssh
while read rsa_key
do
key=$rsa_key
done < 'id_rsa.pub'



curl -u $user https://api.github.com/user/keys -d "{\"title\": \"bka\",\"key\": \"$key\" }"

curl -u $user https://api.github.com/user/repos -d "{\"name\":\"$dirname\"}"



ssh-add id_rsa

ssh -T git@github.com




git clone git@github.com:$user/$dirname.git ~/.env


cd ~/.env

git config user.name $user


git config user.email $user


echo "done"

