#!/bin/bash

##################################
# Author: daiki0508
# Distribution: Debian(Derived)
##################################

# 例外時に処理を終了
set -eu

# root or sudo mode 選択
while :
do
    echo "Please select the current user rights.";
    echo "1) Root permission";
    echo "2) sudo permission";
    echo -n "Please select number: ";
    read permission

    if [ $permission = "1" ] || [ $permission = "2" ]; then
        break
    else
        echo -e "\e[31;1m[!] Please select again number.\e[m";
    fi
done

# port番号
echo -n "port: "
read port

# コンテナ名
echo -n "Container Name: "
read containerName

# イメージ名
echo -n "Image Name: "
read imageName

# 実行
if [ $permission = "1" ]; then
    docker run -itd --privileged -p $port:80 --name $containerName $imageName /sbin/init
else
    ## sudo passwordを要求
    echo -n "sudo password: "
    read password
    echo "$password" | sudo -S docker run -itd --privileged -p $port:80 --name $containerName $imageName /sbin/init
fi