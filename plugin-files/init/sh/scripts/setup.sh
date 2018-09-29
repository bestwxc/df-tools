#!/bin/bash
## 切换到应用目录并获取并将应用目录设置为cur_dir
cur_dir=$(cd `dirname $0`/..;pwd)

source $cur_dir/scripts/color.sh
source $cur_dir/conf/config.sh
source $cur_dir/conf/project.sh

if [ x$1 != x ]
then
    echo "正在将profile设置为$1" | _color_ green bold
    sed -i "s?^active_profile=.*\$?active_profile=$1?g" $cur_dir/conf/config.sh
    echo "请检查下列输出配置是否与配置一致" | _color_ green bold
    grep "active_profile=" $cur_dir/conf/config.sh
else
    echo "请传入当前环境应该激活的profile名称" | _color_ red bold
    echo "当前应用可供选择的profile如下:" | _color_ red bold
    echo $profile_list
    exit -1
fi

sed -i "s?^SERVER_DIR=.*\$?SERVER_DIR=$cur_dir?g" $cur_dir/run.sh
JAR_PATH=`find $cur_dir -name "$application_name*.jar"`
sed -i "s?^JAR_PATH=.*\$?JAR_PATH=$JAR_PATH?g" $cur_dir/conf/config.sh
echo "设置完成" | _color_ green bold
echo "请检查下列信息是否正确" | _color_ green bold
echo "应用部署目录：" | _color_ green bold
grep "SERVER_DIR=" $cur_dir/run.sh
echo "执行JAR目录：" | _color_ green bold
grep "JAR_PATH=" $cur_dir/conf/config.sh

if [ -d $jdk_dir ]
then 
    if [ -f $jdk_dir/bin/java ]
    then
	echo "检测到java命令，请检查下列控制台输出的版本信息是否符合要求" | _color_ green bold
	$jdk_dir/bin/java -version
    else
        echo "未找到java命令，请检查jdk或使用工具重新安装" | _color_ red bold
    fi
else
    echo "$jdk_dir未找到jdk，请检查是否将jdk安装到该目录，或检查是否建立该软连接" | _color_ red bold
fi
