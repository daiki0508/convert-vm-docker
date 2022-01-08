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

# 後片付け
if [ $permission = "1" ]; then
    umount ./input/tmp/mnt
    rm -r ./input/tmp
    rm -r ./output
else
    ## sudo passwordを要求
    echo -n "sudo password: "
    read password
    echo "$password" | sudo -S umount ./input/tmp/mnt
    echo "$password" | sudo -S rm -r ./input/tmp/
    echo "$password" | sudo -S rm -r ./output
fi

# 終了
echo -e "\e[32;1m[*] finished!\e[m";