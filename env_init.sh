#!/bin/sh
echo "plz input ur github acc" 
read user


ssh-keygen -t rsa 
#-C $user

cd ~/.ssh
while read rsa_key
do
key=$rsa_key
done < 'id_rsa.pub'
#read key

echo $key

curl -u $user https://api.github.com/user/keys -d "{\"title\": \"bka\",\"key\": \"$key\" }"

curl -u $user https://api.github.com/user/repos -d "{\"name\":\"mybackup\"}"

ssh -T git@github.com

#git remote add origin git@github.com:$user/mybackup.git



