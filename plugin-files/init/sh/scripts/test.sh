#!/bin/bash

cur_dir=$(cd `dirname $0`/..;pwd)

source $cur_dir/scripts/color.sh
source $cur_dir/conf/config.sh
source $cur_dir/conf/project.sh

if [ -d $jdk_dir ]
then
    if [ -f $jdk_dir/bin/java ]
    then
        ## jdk检测成功
	echo "jdk安装正常" | _color_ green bold
    else
        echo "指定目录未检测到java执行程序，请使用安装工具重新安装" | _color_ red bold
    fi
else
    echo "指定位置未检测到JDK，请使用安装工具重新安装" | _color_ red bold
fi

