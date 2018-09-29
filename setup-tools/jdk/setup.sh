#!/bin/bash
echo "即将安装jdk"
source ./config.sh
source ./scripts/color.sh

mkdir -p "$target_dir"

if [ -d $target_dir/$jdk_dir ]
then
    echo "当前版本已经安装在$target_dir/$jdk_dir，安装停止" | _color_ red bold
else
    echo "未检测到当前版本安装在$target_dir/$jdk_dir，开始安装" | _color_ green bold
    tar -xf ./package/$install_package -C $target_dir
    rm -rf $target_dir/jdk
    ln -s $target_dir/$jdk_dir $target_dir/jdk
    ./test.sh
fi
