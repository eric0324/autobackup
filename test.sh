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

git init

ssh-add id_rsa

ssh -T git@github.com

cd Desktop/backup #cd to working file

git remote add origin git@github.com:$user/$dirname.git



git config user.mail "apple"
git config user.name "apple"

mv ~/.git ./.git



#git commit -m "1"


echo "done"




