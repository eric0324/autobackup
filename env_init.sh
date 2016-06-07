#!/bin/bash
echo "plz input ur github acc" 
read user

#todo: check ~/.ssh
ssh-keygen -t rsa 
#-C $user

key=`cat ~/.ssh/id_rsa.pub`

echo $key

curl -u $user https://api.github.com/user/keys -d "{\"title\": \"create by env_bk\",\"key\": \"$key\" }"

curl -u $user https://api.github.com/user/repos -d "{\"name\":\"$1\"}"

ssh -T git@github.com

#git remote add origin git@github.com:$user/mybackup.git
