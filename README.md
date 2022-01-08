# convert-vm-docker
I think that there may be occasions when the state of VMware or VBox is shared and the same environment is prepared by multiple people.<br>
At that time, I think that ova format files are usually distributed as a sharing method, but as it is, it can not be used with docker.<br>
However, convert_ova_docker.sh converts the ova format file to a docker image and imports it.

## Install
1. Clone this repository.
```bash
$ git clone https://github.com/daiki0508/convert-vm-docker.git
```
2. Run install.sh.
```bash
$ ./install.sh
```

## Usages
<b>Place the ova file you want to convert in the input directory.</b>

- Convert ova format file to docker image and import.
```
$ ./convert_ova_docker.sh ./input/sample.ova
Please select the current user rights.
1) Root permission
2) sudo permission
Please select number: 2
  ____ ___  _   ___     _______ ____ _____    _____     ___
 / ___/ _ \| \ | \ \   / / ____|  _ \_   _|  / _ \ \   / / \
| |  | | | |  \| |\ \ / /|  _| | |_) || |   | | | \ \ / / _ \
| |__| |_| | |\  | \ V / | |___|  _ < | |   | |_| |\ V / ___ \
 \____\___/|_| \_|  \_/  |_____|_| \_\|_|    \___/  \_/_/   \_\

 ____   ___   ____ _  _______ ____
|  _ \ / _ \ / ___| |/ / ____|  _ \
| | | | | | | |   | ' /|  _| | |_) |
| |_| | |_| | |___| . \| |___|  _ <
|____/ \___/ \____|_|\_\_____|_| \_\

[*] conversion file -> sample.ova
[*] unpack ova...
sample.ovf
sample-disk001.vmdk
[*] unpacked sample.ova!
[*] Convert from file format to raw format...
sample-disk001.vmdk  sample.ovf
Please enter the file name of the conversion file: sample-disk001.vmdk
[*] conversion file found!
[*] Please wait...
[*] Converted from vmdk format to raw format!
モデル:  (file)
ディスク /home/daiki0508/convert_vm_docker/input/tmp/sample.raw: 10737418240B
セクタサイズ (論理/物理): 512B/512B
パーティションテーブル: msdos
ディスクフラグ:

番号  開始         終了          サイズ       タイプ    ファイルシステム  フラグ
 1    1048576B     9663676415B   9662627840B  primary   ext4              boot
 2    9664723968B  10736369663B  1071645696B  extended
 5    9664724992B  10736369663B  1071644672B  logical   linux-swap(v1)

Enter the offset value of the disk partition you want to mount: 1048576
[*] mount raw file...
[sudo] daiki0508 のパスワード: [*] mounted raw file!
[*] output tar.gz file...
[*] outputed tar.gz file! -> ./output/sample.tar.gz
[*] import docker image...
sha256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
[*] imported docker image!
[*] do after process...
[*] done after process!
[*] finished!
```
- Run the imported docker image.
```bash
$ ./run.sh
```
- Used when you want to return to the initial state in the event of an error.
```bash
$ ./cleanup.sh
```
