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
    
    nohup $JAVA -jar $JAR_PATH --spring.profiles.active=$active_profile $vmargs &
    sleep 1
    get_pid
    if [ -n "$pid" ]
        then
            echo "启动成功，pid:$pid" | _color_ green bold
        else
            echo "启动失败" | _color_ red bold
        fi
}

## 打印使用方法
print_usage(){
    echo "Usage: bash run.sh {start|stop|restart}" | _color_ green bold
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
    doAlive $1
else
    ## 不存活时
    echo "$application_name当前未存活" | _color_ green bold
    doDead $1
fi
