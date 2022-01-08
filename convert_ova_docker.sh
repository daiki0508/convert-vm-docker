#!/bin/bash

##################################
# Author: daiki0508
# Distribution: Debian(Derived)
##################################

# 例外時に処理を終了
set -eu

# 実行時に指定された引数の数、つまり変数 $# の値が 1 でなければエラー終了。
if [ $# -ne 1 ]; then
  echo -e "\e[31;1m[!] Not enough arguments.\e[m";
  exit 1
fi

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

# bannerの表示
figlet CONVERT OVA DOCKER

# ファイルの存在確認
if [ -e $1 ]; then
    echo -e "\e[32;1m[*] conversion file -> $(basename $1)\e[m";
else
    echo -e "\e[31;1m[!] conversion file didn't exists.\e[m";
    exit 1
fi

# ovaのファイル名を取得
fileName=$(basename $1)

# ovaを解凍
echo "[*] unpack ova...";
mkdir ./input/tmp
tar -xvf $1 -C ./input/tmp/
echo -e "\e[32;1m[*] unpacked $fileName!\e[m";

# vmdk形式からraw形式に変換
echo "[*] Convert from file format to raw format...";
## 解凍された内容を表示
ls ./input/tmp/
### 変換元のファイル名を入力
while :
do
    echo -n "Please enter the file name of the conversion file: "
    read convert_file_name
    if [ -e ./input/tmp/$convert_file_name ]; then
        echo -e "\e[32;1m[*] conversion file found!\e[m";
        break
    else
        echo -e "\e[31;1m[!] conversion file didn't find.\e[m";
    fi
done
## raw形式に変換
rawFileName=${fileName%.*}.raw
echo "[*] Please wait...";
qemu-img convert -f ${convert_file_name##*.} -O raw ./input/tmp/$convert_file_name ./input/tmp/$rawFileName
echo -e "\e[32;1m[*] Converted from vmdk format to raw format!\e[m";

# rawファイルのパーティション情報を表示
parted -s ./input/tmp/$rawFileName unit b print
mkdir ./input/tmp/mnt
echo -n "Enter the offset value of the disk partition you want to mount: ";
read offset

#rawファイルのマウント
echo "[*] mount raw file...";
if [ $permission = "1" ]; then
    mount -o loop,ro,offset=$offset ./input/tmp/$rawFileName ./input/tmp/mnt
else
    ## sudo passwordを要求
    echo -n "sudo password: "
    read password
    echo "$password" | sudo -S mount -o loop,ro,offset=$offset ./input/tmp/$rawFileName ./input/tmp/mnt
fi
echo -e "\e[32;1m[*] mounted raw file!\e[m";

# tar.gz形式のアーカイブを出力
echo "[*] output tar.gz file...";
targzFileName=${fileName%.*}.tar.gz
if [ $permission = "1" ]; then
    tar -C ./input/tmp/mnt -czf ./output/$targzFileName .
else
    echo "$password" | sudo -S tar -C ./input/tmp/mnt -czf ./output/$targzFileName .
fi
echo -e "\e[32;1m[*] outputed tar.gz file! -> ./output/$targzFileName\e[m";

# dockerイメージにインポート
echo "[*] import docker image...";
if [ $permission = "1" ]; then
    docker import ./output/$targzFileName ${fileName%.*}
else
    echo "$password" | sudo -S docker import ./output/$targzFileName ${fileName%.*}
fi
echo -e "\e[32;1m[*] imported docker image!\e[m";

# 後片付け
echo "[*] do after process...";
if [ $permission = "1" ]; then
    umount ./input/tmp/mnt
    rm -r ./input/tmp
else
    echo "$password" | sudo -S umount ./input/tmp/mnt
    echo "$password" | sudo -S rm -r ./input/tmp/
fi
echo -e "\e[32;1m[*] done after process!\e[m";

## 終了
echo -e "\e[32;1m[*] finished!\e[m";