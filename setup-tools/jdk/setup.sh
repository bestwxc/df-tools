#!/bin/bash
echo "即将安装jdk"

cur_dir=$(cd `dirname $0`/..;pwd)

source ../common/color.sh
source ./config.sh

mkdir -p "$target_dir"

if [ -d $target_dir/$jdk_dir ]
then
    echo "当前版本已经安装在$target_dir/$jdk_dir，安装停止" | _color_ red bold
    exit -1
else
    echo "未检测到当前版本安装在$target_dir/$jdk_dir，开始安装" | _color_ green bold
fi

if [ -f ./package/$install_package ]
then
    echo "安装包存在，开始安装" | _color_ green bold
else
    echo "安装包不存在，停止安装" | _color_ red bold
    exit -1
fi
tar -xf ./package/$install_package -C $target_dir
rm -rf $target_dir/jdk
ln -s $target_dir/$jdk_dir $target_dir/jdk
bash test.sh
