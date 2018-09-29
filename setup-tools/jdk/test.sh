#!/bin/bash
source ./config.sh
source ./scripts/color.sh
if [ -d $target_dir/$jdk_dir ]
then
    echo "请检查输出的版本信息是否与$jdk_dir一致" | _color_ green bold
    if [ -d $target_dir/jdk ]
    then
        $target_dir/jdk/bin/java -version
    else
	echo "$target_dir/jdk软连接不存在,检测失败" | _color_ red bold
    fi
else
    echo "当前版本未安装" | _color_ red bold
fi
