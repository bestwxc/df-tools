#!/bin/bash

## 应用部署目录,由setup自动生成，一般情况下，请勿手动修改,用于支持将该执行脚本链接到任意目录使用
SERVER_DIR=/root/workspace/dz-public/dz-kfb-spring-boot-common-file
cd $SERVER_DIR

## 用于加载jni
export LD_LIBRARY_PATH=./:./lib:/usr/local/lib:/usr/local/lib64:$LD_LIBRARY_PATH

## 引入公共配置信息
source ./conf/config.sh
source ./conf/project.sh
source ./scripts/color.sh

## 如果存在则引入机器额外配置
if [ -f $ext_config_file ]
then
    echo "存在额外配置文件$ext_config_file,引入额外配置" | _color_ green bold
    source $ext_config_file
else
    echo "不存在额外配置文件$ext_config_file，创建" | _color_ yellow bold
    config_dir=`dirname $ext_config_file`
    mkdir -p $config_dir
    touch $ext_config_file
    echo '#!/bin/bash' > $ext_config_file
    echo 'vmargs="-Djava.security.egd=file:/dev/./urandom -Xmx1024m -Xms512m"' >> $ext_config_file
    echo 'springargs="$springargs --eureka.instance.ip-address=172.20.26.1 "' >> $ext_config_file
fi

echo "$ext_config_file 内容如下，请检查配置的eureka.instance.ip-address 是否与本机IP匹配" | _color_ yellow bold
cat $ext_config_file
echo "本机IP为：" | _color_ yellow bold
ifconfig |grep "inet addr"|awk -F: '{print $2}'|awk '{print $1}'

## 获取当前应用的pid
get_pid(){
    pid=`ps -ef|grep java|grep "$application_name"|awk '{print $2}'`
}

## kill指定pid应用
stop(){
    kill -9 $1
    sleep 1
    get_pid
    if [ -n "$pid" ]
    then
        echo "停止失败，请检查" | _color_ red bold
    else
        echo "停止成功" | _color_ green bold
    fi
}

## 启动当前应用
start(){
    
    > $SERVER_DIR/nohup.out
    
    nohup $JAVA $vmargs -jar $JAR_PATH --spring.profiles.active=$active_profile $springargs &
    sleep 1
    get_pid
    if [ -n "$pid" ]
        then
            echo "启动成功，pid:$pid" | _color_ green bold
        else
            echo "启动失败" | _color_ red bold
        fi
}

## 查看日志方法
## $1 日志级别
## $2 日志行数
showLog(){
    case $1 in
       "error")
           doShowLog "$log_dir" "$1/$1.log" "$2"
       ;;
       "warn")
           doShowLog "$log_dir" "$1/$1.log" "$2"
       ;;
       "info")
           doShowLog "$log_dir" "$1/$1.log" "$2"
       ;;
       "debug")
           doShowLog "$log_dir" "$1/$1.log" "$2"
       ;;
       *)
       print_log_usage
       ;;
    esac
}

## 实际打印log的方法
## $1 日志文件目录
## $2 日志文件的名称
## $3 日志文件行数
doShowLog(){
    nOfLine=$3
    if [ ! -n "$nOfLine" ]
    then
        nOfLine=200
    fi
    echo "will tail logfile: $1/$2, line: $nOfLine"
    tail -fn $nOfLine $1/$2
}

## 打印使用方法
print_usage(){
    echo "Usage: bash run.sh [start|stop|restart|nohup|log]" | _color_ green bold
}

## 打印显示日志的方法
print_log_usage(){
    echo "Usage: sh run.sh log [error|warn|info|debug] [nOfLine]" | _color_ green bold
}

## 当应用存活时的处理方式
doAlive(){
    case $1 in
        "restart")
            stop $pid
            start
            ;;
        "stop")
            stop $pid
            ;;
        "start")
            echo "当前存活，未执行操作" | _color_ green bold
            ;;
        "nohup")
            doShowLog "$SERVER_DIR" nohup.out $2
            ;;
        "log")
            showLog $2 $3
            ;;
        *)
            print_usage
            ;;
    esac
}

## 应用不存活的处理方式
doDead(){
    case $1 in
        "stop")
            echo "当前未存活，未执行操作" | _color_ green bold
            ;;
        "start")
            start
            ;;
        "restart")
            start
            ;;
        "nohup")
            doShowLog "$SERVER_DIR" nohup.out $2
            ;;
        "log")
            showLog $2 $3
            ;;
        *)
            print_usage
            ;;
    esac
}

## 获取当前应用的pid
get_pid

## 判断是否存在 pid
if [ -n "$pid" ]
then
    ## 存活时
    echo "$application_name当前存活，pid:$pid" | _color_ green bold
    doAlive $1 $2 $3
else
    ## 不存活时
    echo "$application_name当前未存活" | _color_ green bold
    doDead $1 $2 $3
fi
